{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.device;
in {
  config = {
    modules = {
      device = {
        type = "laptop";
        cpu = "intel";
        gpu = "intel";
        monitors = ["eDP-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = false;
      };
      system = {
        fs = ["btrfs" "vfat"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        virtualization.enable = false;
        username = "notashelf";
      };
      usrEnv = {
        isWayland = true;
        desktop = "hyprland";
        useHomeManager = true;
      };
      programs = {
        git.signingKey = "0x84184B8533918D88";
        gaming = {
          enable = false;
          chess = true;
        };

        default = {
          terminal = "foot";
        };

        override = {
          program = {
            libreoffice = false;
          };
        };
      };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };

    boot = {
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
      kernelModules = [
        "iwlwifi"
      ];
    };

    hardware.firmware = with pkgs; [
      rtl8723bs-firmware
      linux-firmware
      intel2200BGFirmware
      rtl8192su-firmware
      rt5677-firmware
      rtl8723bs-firmware
      rtl8761b-firmware
      rtw88-firmware
      zd1211fw
      alsa-firmware
      sof-firmware
      libreelec-dvb-firmware
      broadcom-bt-firmware
      b43Firmware_5_1_138
      b43Firmware_6_30_163_46
      xow_dongle-firmware
      facetimehd-calibration
      facetimehd-firmware
    ];
  };
}
