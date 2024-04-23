{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce mkAfter mkImageMediaOverride;
in {
  boot = {
    # use the latest Linux kernel instead of the default LTS kernel
    # this is useful for hardware support and bug fixes
    kernelPackages = pkgs.linuxPackages_latest;

    # ground control to kernel
    # talk to me kernel
    kernelParams = mkAfter ["noquiet"];

    # no need for systemd in the initrd stage on an installation media
    # being put in to recovery mode, or having systemd in stage one is
    # entirely pointless as this is a live recovery environment.
    initrd.systemd = {
      enable = mkImageMediaOverride false;
      emergencyAccess = mkImageMediaOverride false;
    };

    # Needed for https://github.com/NixOS/nixpkgs/issues/58959
    # tl;dr: ZFS is problematic and we don't want it
    supportedFilesystems = mkForce [
      "btrfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
    ];

    # disable software RAID
    swraid.enable = mkForce false;
  };
}
