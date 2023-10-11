_: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {pkgs, ...}: {
    # configure treefmt
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        shellcheck.enable = true;

        prettier = {
          enable = true;
          package = pkgs.prettierd;
          excludes = ["*.age"];
          settings = {
            editorconfig = true;
          };
        };

        shfmt = {
          enable = true;
          # https://flake.parts/options/treefmt-nix.html#opt-perSystem.treefmt.programs.shfmt.indent_size
          # 0 causes shfmt to use tabs
          indent_size = 0;
        };
      };
    };
  };
}
