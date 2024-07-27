{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule

    ./hooks/exiftool.nix
    ./hooks/prettier.nix
    ./hooks/typos.nix

    # Disabled hooks
    # ./hooks/git-cliff.nix
  ];

  perSystem = {
    inputs',
    pkgs,
    lib,
    ...
  }: let
    inherit (import ./utils.nix {inherit pkgs lib;}) excludes mkHook;
  in {
    pre-commit = {
      check.enable = true;

      settings = {
        # inherit the global exclude list
        inherit excludes;

        # hooks that we want to enable
        hooks = {
          luacheck = mkHook "luacheck" {enable = true;};
          treefmt = mkHook "treefmt" {enable = true;};

          alejandra = mkHook "Alejandra" {
            enable = true;
            package = inputs'.nyxexprs.packages.alejandra-custom;
          };

          actionlint = mkHook "actionlint" {
            enable = true;
            files = "^.github/workflows/"; # only trigger in .github/workflows
          };

          lychee = mkHook "lychee" {
            enable = true;
            excludes = ["^(?!.*\.md$).*"]; # ignore non-markdown
          };

          editorconfig-checker = mkHook "editorconfig" {
            enable = false;
            always_run = true;
          };
        };
      };
    };
  };
}
