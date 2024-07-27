{
  modulesPath,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ./fs
    ./modules
  ];

  config = {
    services.smartd.enable = mkForce false;

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      initrd = {
        availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
        kernelModules = [];
      };

      loader.grub = {
        enable = true;
        useOSProber = mkForce false;
        efiSupport = mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = mkForce "/dev/vda";
      };
    };
  };
}
