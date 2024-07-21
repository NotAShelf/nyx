{pkgs, ...}: {
  modules.system = {
    mainUser = "notashelf";
    fs.enabledFilesystems = ["btrfs" "ext4" "vfat"];
    impermanence.root.enable = true;

    boot = {
      secureBoot = false;
      kernel = pkgs.linuxPackages_xanmod_latest;
      plymouth.enable = true;
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

    yubikeySupport.enable = true;
    autoLogin = true;

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    printing.enable = true;
    emulation.enable = true;

    networking = {
      optimizeTcp = true;
      nftables.enable = true;
      tailscale = {
        enable = true;
        isClient = true;
      };
    };

    security = {
      fixWebcam = false;
      lockModules = true;
      usbguard.enable = true;
    };

    virtualization = {
      enable = true;
      docker.enable = false;
      qemu.enable = true;
      podman.enable = false;
    };
  };
}
