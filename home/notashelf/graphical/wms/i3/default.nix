{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
  device = osConfig.modules.device;
  sys = osConfig.modules.system;
in {
  config = mkIf ((sys.video.enable) && (env.isWayland == false && env.desktop == "i3")) {
    # use i3 as the window manager
    xsession.windowManager.i3.enable = true;

    # enable i3status for the bar
    programs.i3status.enable = true;
  };
}
