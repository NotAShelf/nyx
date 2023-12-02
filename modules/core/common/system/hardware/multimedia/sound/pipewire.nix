{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf isx86Linux;

  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];
  config = mkIf (cfg.enable && dev.hasSound) {
    # able to change scheduling policies, e.g. to SCHED_RR
    security.rtkit.enable = config.services.pipewire.enable;

    services.pipewire = {
      enable = true;

      lowLatency = {
        enable = true;
        # defaults
        # the values below are the defaults, but I'm just putting them here for reference
        quantum = 64;
        rate = 48000;
      };

      # emulation layers
      audio.enable = true;
      wireplumber.enable = true; # session manager
      pulse.enable = true; # PA server emulation
      jack.enable = true; # JACK audio emulation
      alsa = {
        enable = true;
        support32Bit = isx86Linux pkgs; # we're on x86 linux, so we can support 32 bit
      };
    };

    # if for some reason pipewire is disabled, we may enable pulseaudio as backup
    # I don't like PA, but I won't discard it altogether
    hardware.pulseaudio.enable = !config.services.pipewire.enable;

    # write bluetooth rules if and only if pipewire is enabled AND the device has bluetooth
    environment.etc = mkIf (config.services.pipewire.enable && dev.hasBluetooth) {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
