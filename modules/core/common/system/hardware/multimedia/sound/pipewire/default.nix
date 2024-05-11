{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isx86Linux;
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  imports = [./low-latency.nix];
  config = mkIf (cfg.enable && dev.hasSound) {
    # if the device advertises sound enabled, and pipewire is disabled
    # for whatever reason, we may fall back to PulseAudio to ensure
    # that we still have audio. I do not like PA, but bad audio
    # is better than no audio. Though we should always use
    # PipeWire where available
    hardware.pulseaudio.enable = !config.services.pipewire.enable;

    # able to change scheduling policies, e.g. to SCHED_RR
    # sounds server use RealtimeKit (rtkit) to acquire
    # realtime priority
    security.rtkit.enable = config.services.pipewire.enable;

    # Enable PipeWire sound server and additional emulation layers
    # for all kinds of backwards compatibility. Audio on Linux has
    # always been finicky, and this is the best way to ensure that
    # we have the best compatibility with the most software.
    services.pipewire = {
      enable = true;

      # Additional emulation layers to enable on top of PipeWire. The backwards
      # compatibility provided by below options are impeccable and therefore
      # I choose to keep them. On a minimal system, they can (and probably should)
      # be omitted
      audio.enable = true;
      pulse.enable = true; # PulseAudio server emulation
      jack.enable = true; # JACK audio emulation
      alsa = {
        enable = true;
        support32Bit = isx86Linux pkgs; # if we're on x86 linux, we can support 32 bit
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
