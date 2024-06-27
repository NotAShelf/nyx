{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (import ../utils.nix {inherit pkgs lib;}) mkHook;
  in {
    pre-commit.settings = {
      hooks.prettier = mkHook "prettier" {
        enable = true;
        settings = {
          binPath = "${pkgs.prettierd}/bin/prettierd";
          write = true;
        };
      };
    };
  };
}
