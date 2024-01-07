{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
  dev = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins;
          [
            obs-gstreamer
            obs-pipewire-audio-capture
            obs-vkcapture
          ]
          ++ optional env.isWayland
          pkgs.obs-studio-plugins.wlrobs;
      };
    };
  };
}
