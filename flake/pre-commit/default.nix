{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule

    ./hooks/alejandra.nix
    ./hooks/exiftool.nix
    ./hooks/prettier.nix
    ./hooks/typos.nix

    # disabled hooks
    # ./hooks/git-cliff.nix
  ];

  perSystem = {pkgs, ...}: let
    inherit (import ./utils.nix {inherit pkgs;}) excludes mkHook;
  in {
    pre-commit = {
      check.enable = true;

      settings = {
        # inherit the global exclude list
        inherit excludes;

        # hooks that we want to enable
        hooks = {
          actionlint = mkHook "actionlint" {enable = true;};
          luacheck = mkHook "luacheck" {enable = true;};
          treefmt = mkHook "treefmt" {enable = true;};
          editorconfig-checker = mkHook "editorconfig" {
            enable = false;
            always_run = true;
          };
        };
      };
    };
  };
}
