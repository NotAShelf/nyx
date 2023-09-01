{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice;

  env = osConfig.modules.usrEnv;
  acceptedTypes = ["lite" "hybrid" "laptop" "desktop"];
in {
  config = mkIf (isAcceptedDevice osConfig acceptedTypes) {
    # fake a tray to let apps start
    # https://github.com/nix-community/home-manager/issues/2064
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
