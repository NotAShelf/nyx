{
  config,
  lib,
  pkgs,
  ...
}: let
  sys = config.modules.system;
  env = config.modules.usrEnv;
  inherit (lib) mkForce mkIf;
in {
  config = mkIf sys.video.enable {
    xdg.portal = {
      config = {
        common = {
          default = [
            "gtk"
          ];

          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
      };
    };
  };
}
