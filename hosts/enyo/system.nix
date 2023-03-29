{
  config,
  lib,
  inputs,
  self,
  ...
}:
with lib; {
  config = {
    modules = {
      device = {
        type = "desktop";
        cpu = "amd";
        gpu = "amd";
        monitors = ["HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        fs = ["btrfs" "vfat" "ntfs" "exfat"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        virtualization = {
          enable = true;
          qemu.enable = true;
        };
        username = "notashelf";

        networking = {
          optimizeTcp = true;
        };
      };
      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
        autologin = true;
      };
      programs = {
        git.signingKey = "F0D14CCB5ED5AA22 ";

        gaming = {
          enable = true;
          chess = true;
        };
        default = {
          terminal = "foot";
        };
        override = {};
      };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    boot = {
      kernelParams = [
        "nohibernate"
      ];

      loader = {
        grub.enable = true;
        systemd-boot.enable = false;
      };
    };

    console.earlySetup = true;
  };
}
