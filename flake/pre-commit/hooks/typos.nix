{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.lists) concatLists;
    inherit (import ../utils.nix {inherit pkgs;}) toTOML mkHook;

    typosConfig = toTOML "config.toml" {
      default.extend-words = {
        "ags" = "ags";
        "thumbnailers" = "thumbnailers";
        "flate" = "flate";
        "noice" = "noice";
        "Pn" = "Pn";
        "nitch" = "nitch";
        "fo" = "fo";
        "muh" = "muh";
        "HDA" = "HDA";
        "CROS" = "CROS";
      };
    };
  in {
    pre-commit.settings.hooks.typos = let
      ignoredFiles = [
        "CHANGELOG.md"
        "source.json"
        "keys.nix"
        "autocmds.lua"
      ];

      ignoredPatterns = [
        "r'.+\.zsh$'"
        "r'.+\.age$'"
      ];

      excludedFiles = concatLists [ignoredFiles ignoredPatterns];
    in
      mkHook "typos" {
        enable = true;
        excludes = excludedFiles;
        settings = {
          configPath = typosConfig.outPath;
        };
      };
  };
}
