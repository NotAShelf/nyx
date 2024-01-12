{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.system.media = {
    mpv.enable = mkEnableOption "mpv media player";
    addDefaultPackages = mkOption {
      type = types.bool;
      default = true;
      description = "Add default mpv packages";
    };

    extraDefaultPackages = mkOption {
      type = with types; listOf package;
      default = [];
      description = "Add extra mpv packages";
    };
  };
}
