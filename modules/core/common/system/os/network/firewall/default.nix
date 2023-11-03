{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkForce;
  dev = config.modules.device;
in {
  imports = [
    ./fail2ban.nix
    ./nftables.nix
  ];

  config = {
    services = {
      # enable opensnitch firewall
      # inactive until opensnitch UI is opened
      opensnitch.enable = true;
    };

    networking = {
      firewall = {
        enable = true;
        package = mkDefault pkgs.iptables-nftables-compat;
        allowedTCPPorts = [443 8080];
        allowedUDPPorts = [];
        allowPing = dev.type == "server";
        logReversePathDrops = true;
        logRefusedConnections = false; # avoid log spam
        checkReversePath = mkForce false; # Don't filter DHCP packets, according to nixops-libvirtd
      };
    };
  };
}
