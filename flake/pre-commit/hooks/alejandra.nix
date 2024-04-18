{
  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    inherit (import ../utils.nix {inherit pkgs;}) mkHook;
  in {
    pre-commit.settings = {
      hooks.alejandra = mkHook "Alejandra" {
        enable = true;
        package = inputs'.nyxpkgs.packages.alejandra-no-ads;
      };
    };
  };
}
