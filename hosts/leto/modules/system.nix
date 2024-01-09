{
  config.modules.system = {
    mainUser = "notashelf";
    fs = ["vfat" "exfat" "ext4"];
    video.enable = false;
    sound.enable = false;
    bluetooth.enable = false;
    printing.enable = false;

    boot = {
      secureBoot = false;
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
      tailscale = {
        enable = false;
        isServer = true;
        isClient = false;
      };
    };
  };
}
