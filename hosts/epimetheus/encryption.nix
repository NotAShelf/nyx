_: {
  # mildly improves performance for the disk encryption
  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
    "usb_storage"
  ];

  boot.initrd.luks.devices."enc" = {
    allowDiscards = true;
    keyFileSize = 4096;
    keyFile = "/dev/disk/by-id/usb-Generic_Flash_Disk_B314B63E-0:0";
  };
}
