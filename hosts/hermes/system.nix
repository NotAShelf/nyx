{
  mainUser = "notashelf";
  fs = ["btrfs" "ext4" "vfat"];
  video.enable = true;
  sound.enable = true;
  bluetooth.enable = true;
  printing.enable = true;
  emulation.enable = true;
  impermanence.root.enable = true;
  yubikeySupport.enable = true;
  autologin = true;

  boot = {
    loader = "systemd-boot";
    enableKernelTweaks = true;
    enableInitrdTweaks = true;
    loadRecommendedModules = true;
    tmpOnTmpfs = true;
    plymouth.enable = true;
    encryption.enable = true;
  };

  networking = {
    optimizeTcp = true;
    useTailscale = true;
  };

  security = {
    fixWebcam = false;
    secureBoot = false;
  };

  virtualization = {
    enable = false;
    docker.enable = false;
    qemu.enable = false;
    podman.enable = false;
  };
}
