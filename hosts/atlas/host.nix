{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    ./fs
    ./modules
  ];
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

      graphics = {
        # this only takes effect in 64 bit systems
        enable32Bit = mkForce false;
      };
    };

    boot = {
      kernelModules = mkForce ["bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr"];
      supportedFilesystems = mkForce ["ext4" "vfat"];
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
