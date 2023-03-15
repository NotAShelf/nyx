_: {
  # mildly improves performance for the disk encryption
  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];
}
