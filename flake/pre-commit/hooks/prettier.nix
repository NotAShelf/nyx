{
  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    inherit (import ../lib.nix {inherit pkgs;}) mkHook;
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
