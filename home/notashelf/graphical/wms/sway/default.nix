{
  lib,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
in {
  imports = [./config.nix];
  config = mkIf ((sys.video.enable) && (env.isWayland && (env.desktop == "sway"))) {
    wayland.windowManager.sway = {
      enable = true;
    };
  };
}
