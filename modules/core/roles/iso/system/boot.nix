{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  boot = {
    # use the latest Linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # talk to me kernel
    kernelParams = lib.mkAfter ["noquiet"];

    # no need for systemd in the initrd stage on an installation media
    # being put in to recovery mode, or having systemd in stage one is
    # entirely pointless
    initrd.systemd = {
      enable = lib.mkImageMediaOverride false;
      emergencyAccess = lib.mkImageMediaOverride true;
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
