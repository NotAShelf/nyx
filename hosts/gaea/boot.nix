{
  pkgs,
  lib,
  ...
}: {
  boot.kernelParams = lib.mkAfter ["noquiet"];

  boot.initrd.systemd.enable = lib.mkImageMediaOverride false;
  boot.initrd.systemd.emergencyAccess = lib.mkImageMediaOverride true;

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];
}
