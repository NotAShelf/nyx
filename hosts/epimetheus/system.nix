{
  config,
  lib,
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
        gpu = "hybrid-nv"; # nvidia drivers :b:roke
        monitors = ["eDP-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        mainUser = "notashelf";
        fs = ["btrfs" "ext4" "vfat"];

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
        emulation.enable = true;

        networking = {
          optimizeTcp = true;
        };

        security = {
          fixWebcam = false;
          secureBoot = false;
        };

        virtualization = {
          enable = true;
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
        nvidiaPersistenced = mkForce false;

        open = mkForce false;

        prime = {
          offload.enable = mkForce true;
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
          # The passive default severely degrades performance.
          "intel_pstate=active"
        ]
        ++ optionals ((device.cpu == "intel") && (device.gpu != "hybrid-nv")) [
          "i915.enable_fbc=1"
          "i915.enable_psr=2"
        ];

      kernelModules = [
        "sdhci" # fix microsd cards
      ];
    };

    services.btrfs.autoScrub = {fileSystems = ["/"];};

    home-manager.users.notashelf.systemd.user.startServices = "legacy";

    console.earlySetup = true;
  };
}
