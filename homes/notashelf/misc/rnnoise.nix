{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig.modules) device;

  format = pkgs.formats.json {};

  acceptedTypes = ["desktop" "laptop"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    # Write a PipeWire userspace configuration based on werman's noise-supression-for-voice
    # for usage instructions, see:
    # <https://github.com/werman/noise-suppression-for-voice?tab=readme-ov-file#linux>
    xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".source = format.generate "99-input-denoising.conf" {
      "context.modules" = [
        {
          "name" = "libpipewire-module-filter-chain";
          "args" = {
            "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";
            "filter.graph" = {
              "nodes" = [
                {
                  "type" = "ladspa";
                  "name" = "rnnoise";
                  "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  "label" = "noise_suppressor_mono"; # or "noise_suppressor_stereo", consumes twice the resources
                  "control" = {
                    "VAD Threshold (%)" = 50.0;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 0;
                  };
                }
              ];
            };
            "audio.position" = ["FL" "FR"];
            "capture.props" = {
              "node.name" = "effect_input.rnnoise";
              "node.passive" = true;
              "audio.rate" = 48000;
            };
            "playback.props" = {
              "node.name" = "effect_output.rnnoise";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
  };
}
