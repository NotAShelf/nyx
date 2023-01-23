{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
in {
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
}
