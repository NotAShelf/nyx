{
  config,
  lib,
  ...
}: {
  # mildly improves performance for the disk encryption
  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
    "usb_storage"
  ];

  services.lvm.enable = lib.mkForce true;

  boot.initrd.luks.devices."enc" = {
    # improve performance on ssds
    bypassWorkqueues = true;
    preLVM = true;

    # the device with the maching id will be searched for the key file
    # keyFile = "/dev/disk/by-id/usb-Generic_Flash_Disk_B314B63E-0:0";
    # keyFileSize = 4096;

    # if keyfile is not there, fall back to cryptsetup password
    fallbackToPassword = !config.boot.initrd.systemd.enable; # IMPLIED BY config.boot.initrd.systemd.enable
  };
}
