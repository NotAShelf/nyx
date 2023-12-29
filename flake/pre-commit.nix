{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: let
    # configure a general exclude list
    excludes = ["flake.lock" "r'.+\.age$'" "r'.+\.sh$'"];

    # mkHook just defaults failfast to true
    # and sets the description from the name
    mkHook = name: prev:
      {
        inherit excludes;
        description = "pre-commit hook for ${name}";
        fail_fast = true;
        verbose = true;
      }
      // prev;
  in {
    pre-commit = {
      check.enable = true;

      settings = {
        # inherit the global exclude list
        inherit excludes;

        # hooks that we want to enable
        hooks = {
          alejandra = mkHook "Alejandra" {enable = true;};
          actionlint = mkHook "actionlint" {enable = true;};
          treefmt = mkHook "treefmt" {enable = true;};
          prettier = mkHook "prettier" {enable = true;};
          luacheck = mkHook "luacheck" {enable = true;};

          mkdocs-linkcheck = mkHook "mkdocs-linkcheck" {
            enable = true;
            files = "r'.+\.md$'";
          };

          editorconfig-checker = mkHook "editorconfig" {
            enable = false;
            always_run = true;
          };
        };

        # why is this settings.settings.<hook> instead of <hook>.settings?
        # fuck you that's why
        # - numtide, probably
        settings = {
          prettier = {
            binPath = "${pkgs.prettierd}/bin/prettierd";
            write = true;
          };

          treefmt = {
            package = config.treefmt.build.wrapper;
          };
        };
      };
    };
  };
}
