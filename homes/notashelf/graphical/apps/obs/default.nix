{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
  device = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins;
          [
            obs-gstreamer
            obs-pipewire-audio-capture
            obs-vkcapture
          ]
          ++ optional (env.isWayland)
          pkgs.obs-studio-plugins.wlrobs;
      };
    };
  };
}
