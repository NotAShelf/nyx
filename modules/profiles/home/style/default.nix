{
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  replaceSpacesWithHyphens = inputString: builtins.replaceStrings [" "] "-" inputString;
in {
  imports = [./catppuccin-mocha];

  options = {
    modules.style = {
      theme = lib.mkOption {
        type = with types; nullOr (enum ["catppuccin-mocha" "tokyo-night"]);
        default = null;
        description = "The default theme pack to be used";
      };

      slug = lib.mkOption {
        type = types.str;
        default = replaceSpacesWithHyphens config.modules.style.theme;
        description = "";
      };
    };
  };
}
