{
  config,
  lib,
  ...
}: {
  config = {
    networking.domain = "notashelf.dev";
    services.smartd.enable = lib.mkForce false;

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      loader.grub = {
        enable = true;
        useOSProber = lib.mkForce false;
        efiSupport = lib.mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = lib.mkForce "/dev/disk/by-label/nixos";
        forceInstall = true;
      };
    };
  };
}
