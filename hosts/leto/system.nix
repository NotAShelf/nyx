{
  modulesPath,
  config,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  config = {
    services.smartd.enable = lib.mkForce false;

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      initrd = {
        availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
        kernelModules = [];
      };

      loader.grub = {
        enable = true;
        useOSProber = lib.mkForce false;
        efiSupport = lib.mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = lib.mkForce "/dev/vda";
      };
    };
  };
}
