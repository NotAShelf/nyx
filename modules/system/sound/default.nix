{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.sound;
  device = config.modules.device;
in {
  options.modules.system.sound = {enable = mkEnableOption "sound";};

  config = mkIf (cfg.enable && device.hasSound) {
    sound.enable = true;
    # able to change scheduling policies, e.g. to SCHED_RR
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    hardware.pulseaudio.enable = false;
    environment.etc = mkIf device.hasBluetooth {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  };
}
