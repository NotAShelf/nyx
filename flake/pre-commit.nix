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
        fail_fast = true; # running hooks if this hook fails
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
          luacheck = mkHook "luacheck" {enable = true;};
          treefmt = mkHook "treefmt" {enable = true;};

          editorconfig-checker = mkHook "editorconfig" {
            enable = false;
            always_run = true;
          };

          prettier = mkHook "prettier" {
            enable = true;
            settings = {
              binPath = "${pkgs.prettierd}/bin/prettierd";
              write = true;
            };
          };
        };
      };
    };
  };
}
