{
  pkgs,
  lib,
  ...
}: {
  # talk to me kernel
  boot.kernelParams = lib.mkAfter ["noquiet"];

  # no need for systemd in the initrd stage on an installation media, it's a one night stand
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
