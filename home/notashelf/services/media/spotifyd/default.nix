{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  password_cmd = "${pkgs.coreutils}/bin/tail -1 /run/agenix/spotify";
  username_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify";
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      spotifyd = {
        enable = false;
        package = pkgs.spotifyd.override {withMpris = true;};
        settings.global = {
          autoplay = true;
          backend = "pulseaudio";
          bitrate = 320;
          cache_path = "${config.xdg.cacheHome}/spotifyd";
          device_type = "computer";
          password_cmd = password_cmd;
          use_mpris = true;
          username_cmd = username_cmd;
          volume_normalisation = true;
        };
      };
    };
  };
}
