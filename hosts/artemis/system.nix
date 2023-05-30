{
  config,
  lib,
  inputs,
  self,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = {
    modules = {
      device = {
        type = "lite";
        cpu = "intel";
        gpu = "intel"; # nvidia drivers :b:roke
        monitors = [];
        hasBluetooth = false;
        hasSound = true;
        hasTPM = false;
      };
      system = {
        username = "notashelf";
        fs = ["btrfs" "vfat"];
        video.enable = true;
        sound.enable = false;
        bluetooth.enable = false;
        printing.enable = false;

        networking = {
          optimizeTcp = false;
        };

        security = {
          fixWebcam = false;
        };

        virtualization = {
          enable = false;
          docker.enable = false;
          qemu.enable = false;
          podman.enable = false;
        };
      };
      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        autologin = true;
        useHomeManager = true;
      };
      programs = {
        git.signingKey = "0x05A3BD53FEB32B81";

        gaming = {
          enable = false;
          chess.enable = false;
        };
        default = {
          terminal = "foot";
        };
        override = {};
      };
    };

    boot = {
      kernelParams =
        [
          "nohibernate"
        ]
        ++ optionals ((device.cpu == "intel") && (device.gpu != "hybrid-nv")) [
          "i915.enable_fbc=1"
          "i915.enable_psr=2"
        ];
    };

    services.btrfs.autoScrub = {fileSystems = ["/"];};

    console.earlySetup = true;
  };
}
