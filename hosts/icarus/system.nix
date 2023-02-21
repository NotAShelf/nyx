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
        hasTPM = true;
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
    };

    boot = {
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
    };

    environment.systemPackages = [
      pkgs.linuxKernel.packages.linux_latest_libre.broadcom_sta
    ];
  };
}
