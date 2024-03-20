{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  dev = osConfig.modules.device;

  credientals = {
    password_cmd = "${pkgs.coreutils}/bin/tail -1 /run/agenix/spotify";
    username_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify";
  };

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    services = {
      spotifyd = {
        enable = false;
        package = pkgs.spotifyd.override {withMpris = true;};
        settings.global = {
          inherit (credientals) password_cmd username_cmd;
          cache_path = "${config.xdg.cacheHome}/spotifyd";
          device_type = "computer";
          use_mpris = true;
          autoplay = true;

          # audio settings
          volume_normalisation = true;
          backend = "pulseaudio";
          bitrate = 320;
        };
      };
    };
  };
}
