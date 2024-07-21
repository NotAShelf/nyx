{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.dolphin.enable {
    home.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      libssh # for sftp

      # For thumbnailing support in Dolphin
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers
    ];

    xdg = {
      configFile."dolphinrc".source = ./config/dolphinrc;
      dataFile = {
        "kxmlgui5/dolphin/dolphinui.rc".source = ./config/dolphinui.rc;
        "dolphin/view_properties/global/.directory".source = ./config/view_properties;
      };
    };
  };
}
