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
    # if for some reason pipewire is disabled, we may enable pulseaudio as backup
    # I don't like PA, but I won't discard it altogether
    hardware.pulseaudio.enable = !config.services.pipewire.enable;

    # able to change scheduling policies, e.g. to SCHED_RR
    security.rtkit.enable = config.services.pipewire.enable;

    services = {
      pipewire = {
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
        pulse.enable = true; # PA server emulation
        jack.enable = true; # JACK audio emulation
        alsa = {
          enable = true;
          support32Bit = isx86Linux pkgs; # if we're on x86 linux, we can support 32 bit
        };

        # session manager
        wireplumber = {
          inherit (config.services.pipewire) enable;
          configPackages = lib.optionals dev.hasBluetooth [
            (pkgs.writeTextDir "share/bluetooth.lua.d/51-bluez-config.lua" ''
              bluez_monitor.properties = {
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
              }
            '')
          ];
        };
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
