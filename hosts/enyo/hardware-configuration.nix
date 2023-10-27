{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
    fsType = "btrfs";
    options = ["subvol=log"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E20E-9940";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/62fc1f62-55ae-432d-8623-74ea6511410c";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
