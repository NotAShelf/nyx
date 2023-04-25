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
        fs = ["btrfs" "vfat"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;

        networking = {
          optimizeTcp = true;
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

        cli.enable = true;
        gui.enable = true;

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

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/persist".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      nvidia = mkIf (builtins.elem device.gpu ["nvidia" "hybrid-nv"]) {
        open = mkForce false;

        prime = {
          offload.enable = true;
          # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
          intelBusId = "PCI:0:2:0";

          # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
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

    services.btrfs.autoScrub = {fileSystems = ["/"];};

    home-manager.users.notashelf.systemd.user.startServices = mkForce "legacy";

    console.earlySetup = true;
  };
}
