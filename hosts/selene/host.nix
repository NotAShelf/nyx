{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    ./fs
    ./modules

    ./nftables.nix
  ];

  config = {
    networking.domain = "notashelf.dev";
    services.smartd.enable = mkForce false;

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      loader.grub = {
        enable = true;
        useOSProber = mkForce false;
        efiSupport = mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = mkForce "/dev/disk/by-label/nixos";
        forceInstall = true;
      };
    };
  };
}
