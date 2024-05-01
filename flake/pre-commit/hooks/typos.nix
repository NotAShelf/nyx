{
  perSystem = {pkgs, ...}: let
    inherit (import ../utils.nix {inherit pkgs;}) toTOML mkHook;

    typosConfig = toTOML "config.toml" {
      default.extend-words = {
        "ags" = "ags";
        "thumbnailers" = "thumbnailers";
        "flate" = "flate";
        "noice" = "noice";
        "Pn" = "Pn";
        "nitch" = "nitch";
      };
    };
  in {
    pre-commit.settings.hooks.typos = mkHook "typos" {
      enable = true;
      excludes = ["CHANGELOG.md" "source.json" "r'.+\.zsh$'" "r'.+\.age$'" "keys.nix"];
      settings = {
        configPath = typosConfig.outPath;
      };
    };
  };
}
