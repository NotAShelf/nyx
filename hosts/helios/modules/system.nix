{pkgs, ...}: {
  config.modules.system = {
    mainUser = "notashelf";
    fs.enabledFilesystems = ["vfat" "exfat" "ext4"];
    video.enable = false;
    sound.enable = false;
    bluetooth.enable = false;
    printing.enable = false;

    boot = {
      secureBoot = false;
      kernel = pkgs.linuxPackages_latest;
      loader = "grub";
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = false;
    };

    virtualization = {
      enable = true;
      qemu.enable = true;
      docker.enable = true;
    };

    networking = {
      optimizeTcp = false;
      tarpit.enable = true;
      nftables.enable = true;
      tailscale = {
        enable = true;
        isServer = true;
        isClient = false;
      };
    };

    programs = {
      git.signingKey = "";

      cli.enable = true;
      gui.enable = false;
    };
  };
}
