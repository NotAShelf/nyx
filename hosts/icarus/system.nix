{
  config = {
    modules = {
      device = {
        type = "hybrid";
        cpu.type = "intel";
        gpu.type = "intel";
        monitors = ["eDP-1"];
        hasBluetooth = false;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        mainUser = "notashelf";
        fs = ["btrfs" "ext4" "vfat"];
        autoLogin = true;

        boot = {
          secureBoot = false;
          loader = "systemd-boot";
          enableKernelTweaks = true;
          initrd.enableTweaks = true;
          loadRecommendedModules = true;
          tmpOnTmpfs = false;
        };

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        emulation.enable = false;

        networking = {
          optimizeTcp = true;
          tailscale = {
            enable = true;
            isClient = true;
          };
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
        useHomeManager = true;
      };

      programs = {
        git.signingKey = "0x148C61C40F80F8D6";

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
      "/persist".options = ["compress=zstd"];
      "/var/log".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };

    boot = {
      kernelModules = ["iwlwifi"];
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
    };
  };
}
