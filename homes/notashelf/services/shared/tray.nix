{
  osConfig,
  lib,
  ...
}: let
  env = osConfig.modules.usrEnv;
in {
  # assume system is headless if desktop is not set
  config = lib.mkIf (env.desktop != "") {
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
