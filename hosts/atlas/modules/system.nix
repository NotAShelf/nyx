{
  config.modules.system = {
    mainUser = "notashelf";
    fs = ["ext4" "vfat" "ntfs" "exfat"];
    autoLogin = false;

    boot = {
      loader = "none";
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      tmpOnTmpfs = false;
    };

    video.enable = false;
    sound.enable = false;
    bluetooth.enable = false;
    printing.enable = false;
    emulation.enable = false;

    virtualization.enable = false;

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
  };
}
