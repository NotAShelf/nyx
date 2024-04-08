{
  modulesPath,
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

      deviceTree.enable = true;

      opengl = {
        # this only takes effect in 64 bit systems
        driSupport32Bit = mkForce false;
      };
    };

    boot = {
      kernelModules = lib.mkForce ["bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr"];
      supportedFilesystems = lib.mkForce ["ext4" "vfat"];
      loader.grub.enable = mkForce false;
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
