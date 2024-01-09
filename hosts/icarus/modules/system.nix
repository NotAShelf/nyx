{
  config.modules.system = {
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

    programs = {
      cli.enable = true;
      gui.enable = true;

      git.signingKey = "0x148C61C40F80F8D6";

      gaming = {
        enable = false;
        chess.enable = false;
      };

      default = {
        terminal = "foot";
      };
    };
  };
}
