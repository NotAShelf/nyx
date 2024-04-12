{
  perSystem = {pkgs, ...}: let
    inherit (import ../lib.nix {inherit pkgs;}) toTOML mkHook;

    typosConfig = toTOML "config.toml" {
      default.extend-words = {
        "ags" = "ags";
        "thumbnailers" = "thumbnailers";
      };
    };
  in {
    pre-commit.settings.hooks.typos = mkHook "typos" {
      enable = true;
      settings.configPath = typosConfig.outPath;
    };
  };
}
