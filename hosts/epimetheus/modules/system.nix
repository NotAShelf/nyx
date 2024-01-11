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
      tmpOnTmpfs = true;
    };

    encryption = {
      enable = true;
      device = "enc";
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
    };

    virtualization = {
      enable = true;
      docker.enable = false;
      qemu.enable = true;
      podman.enable = false;
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
    };
  };
}
