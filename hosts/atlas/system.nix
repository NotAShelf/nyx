{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  config = {
    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      git
      neovim
    ];

    hardware = {
      raspberry-pi."4" = {
        # Enable GPU acceleration
        fkms-3d.enable = true;
        apply-overlays-dtmerge.enable = true;
      };

      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };

      opengl = {
        # this only takes effect in 64 bit systems
        driSupport32Bit = mkForce false;
      };
    };

    boot = {
      kernelModules = lib.mkForce ["bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr"];
      supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" "vfat"];
      loader.grub.enable = mkForce false;
    };

    fileSystems = {
      "/" = {
        device = lib.mkForce "/dev/disk/by-label/NIXOS";
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    nixpkgs = {
      config.allowUnsupportedSystem = true;
      hostPlatform.system = "armv7l-linux";
      buildPlatform.system = "x86_64-linux";
    };

    console.enable = false;

    system.stateVersion = "24.05";
  };
}
