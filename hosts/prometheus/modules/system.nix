{
  config.modules.system = {
    mainUser = "notashelf";
    fs = ["btrfs" "vfat" "ntfs"];
    autoLogin = true;

    boot = {
      loader = "systemd-boot";
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = true;
    };

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = false;
    printing.enable = false;

    networking = {
      optimizeTcp = true;
      tailscale = {
        enable = true;
        isClient = true;
      };
    };

    virtualization = {
      enable = false;
      docker.enable = false;
      qemu.enable = true;
      podman.enable = false;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      git.signingKey = "419DBDD3228990BE";

      gaming = {
        enable = true;
        chess.enable = true;
      };

      default = {
        terminal = "foot";
      };
    };
  };
}
