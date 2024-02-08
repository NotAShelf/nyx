{
  config,
  lib,
  ...
}: let
  sys = config.modules.system;
  inherit (lib) mkIf;
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
