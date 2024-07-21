{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    inputs',
    config,
    pkgs,
    lib,
    ...
  }: {
    # Provide a formatter package for `nix fmt`. Setting this
    # to `config.treefmt.build.wrapper` will use the treefmt
    # package wrapped with my desired configuration.
    formatter = config.treefmt.build.wrapper;

    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;

      settings = {
        global.excludes = ["*.age" "*.envrc" "parts/templates" "*/sources.json"];
        formatter.yamlfmt = {
          includes = [".github/workflows/*.{yaml,yml}"];
          excludes = ["*/.eslintrc.yml" "*/pnpm-lock.yaml"];
        };
      };

      # Most often than not, most of those checks will not run on baremetal. Which
      # means that we can afford to be generous with what formatters we provide.
      programs = {
        taplo.enable = true;
        yamlfmt = {
          enable = true;
          package = let
            # This is, from what I can tell, is the only way to be able to
            # pass a config file to formatters in treefmt. Horrible, HORRIBLE
            # design choice.
            config = pkgs.writeText "yamlfmt-config.yaml" (builtins.toJSON {
              line_ending = "lf"; # no windows compat, sorry
              formatter = {
                type = "basic";
                retain_line_breaks = true;
              };
            });
          in
            # Write a script that calls for yamlfmt with the custom config
            # written to the file in store.
            pkgs.writeShellScriptBin "yamlfmt-custom-config" ''
              ${lib.getExe pkgs.yamlfmt} -conf ${config.outPath}
            '';
        };

        alejandra = {
          enable = true;
          package = inputs'.nyxexprs.packages.alejandra-custom;
        };

        shellcheck.enable = true; # cannot be configured, errors on basic bash convention

        prettier = {
          enable = true;
          package = pkgs.prettierd;
          settings.editorconfig = true;
        };

        shfmt = {
          enable = true;
          # https://flake.parts/options/treefmt-nix.html#opt-perSystem.treefmt.programs.shfmt.indent_size
          indent_size = 2; # set to 0 to use tabs
        };
      };
    };
  };
}
