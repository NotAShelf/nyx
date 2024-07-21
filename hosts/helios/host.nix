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

    # https://docs.hetzner.com/cloud/networks/faq/#are-any-ip-addresses-reserved
    networking = {
      defaultGateway = {
        interface = "ens3";
        address = "172.31.1.1";
      };
      defaultGateway6 = {
        interface = "ens3";
        address = "fe80::1";
      };
    };
  };
}
