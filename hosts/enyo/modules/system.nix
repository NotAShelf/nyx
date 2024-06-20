{pkgs, ...}: {
  config.modules.system = {
    mainUser = "notashelf";
    fs.enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];
    autoLogin = true;

    boot = {
      loader = "systemd-boot";
      secureBoot = false;
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = false;
      plymouth = {
        enable = true;
        withThemes = false;
      };
    };

    containers = {
      enabledContainers = ["alpha"];
    };

    yubikeySupport.enable = true;

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = false;
    printing.enable = false;
    emulation.enable = true;

    virtualization = {
      enable = true;
      qemu.enable = true;
      docker.enable = true;
    };

    networking = {
      optimizeTcp = true;
      nftables.enable = true;
      tailscale = {
        enable = true;
        isClient = true;
        isServer = false;
      };
    };

    security = {
      tor.enable = true;
      fixWebcam = false;
      lockModules = true;
      auditd.enable = true;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      spotify.enable = true;

      git.signingKey = "0xAF26552424E53993 ";

      gaming = {
        enable = true;
      };

      default = {
        terminal = "foot";
      };

      libreoffice.enable = true;
    };
  };
}
