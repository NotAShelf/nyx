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
        type = "laptop";
        cpu = "intel";
        gpu = "intel"; # nvidia drivers :b:roke
        monitors = ["eDP-1" "HDMI-A-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        username = "notashelf";
        fs = ["btrfs" "vfat" "ntfs"];

        boot = {
          loader = "systemd-boot";
          enableKernelTweaks = true;
          enableInitrdTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = true;
        };

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;

        networking = {
          optimizeTcp = true;
        };

        virtualization = {
          enable = false;
          docker.enable = false;
          qemu.enable = true;
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
        git.signingKey = "419DBDD3228990BE";

        cli.enable = true;
        gui.enable = true;

        gaming = {
          enable = true;
          chess.enable = true;
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

    hardware = {
      nvidia = mkIf (builtins.elem device.gpu ["nvidia" "hybrid-nv"]) {
        open = mkForce false;

        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
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

    console.earlySetup = true;
  };
}
