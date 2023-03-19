{
  config,
  lib,
  inputs,
  self,
  ...
}: {
  config = {
    modules = {
      device = {
        type = "desktop";
        cpu = "amd";
        gpu = "amd";
        monitors = ["HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = false;
      };
      system = {
        fs = ["btrfs" "vfat" "ntfs"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = true;
        printing.enable = false;
        virtualization.enable = true;
        username = "notashelf";
      };
      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
        autologin = true;
      };
      programs = {
        git.signingKey = "0x3BD06CF51250A715";

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
    };

    console.earlySetup = true;
  };
}
