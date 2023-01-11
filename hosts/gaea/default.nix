{
  config,
  lib,
  pkgs,
  ...
}: {
  # use networkmanager in the live environment
  networking.networkmanager.enable = lib.mkForce true;
  networking.wireless.enable = lib.mkForce false;

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  # system packages for the base installer
  environment.systemPackages = with pkgs; [neovim nano];
  users.extraUsers.root.password = "";
  boot.loader.grub.device = "nodev";

  # faster compression in exchange for larger iso size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
