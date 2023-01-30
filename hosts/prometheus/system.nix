{
  config,
  lib,
  inputs,
  self,
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
        gpu = "intel"; # nvidia drivers :b:roke
        monitors = ["eDP-1" "HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        fs = ["btrfs" "vfat" "ntfs"];
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
          enable = true;
          chess = true;
        };
        default = {
          terminal = "foot";
        };
        override = {
          program = {
            libreoffice = true;
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
      nvidia = {
        open = mkForce false;

        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot = {
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
    };

    console.earlySetup = true;
  };
}
