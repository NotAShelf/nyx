{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce;
  dev = config.modules.device;
  cfg = config.networking.nftables;
in {
  imports = [
    ./nftables

    ./fail2ban.nix
    ./tarpit.nix
  ];

  config = {
    # enable opensnitch firewall
    # inactive until opensnitch UI is opened
    # since the UI cannot be opened on servers, we
    # disable it if dev.type is server
    services.opensnitch.enable = dev.type != "server";

    networking.firewall = {
      enable = !cfg.enable;
      package =
        if cfg.enable
        then pkgs.iptables-nftables-compat
        else pkgs.iptables;
      allowedTCPPorts = [443 8080];
      allowedUDPPorts = [];
      allowPing = dev.type == "server";
      logReversePathDrops = true;
      logRefusedConnections = false; # avoid log spam
      # Leaks IPv6 route table entries due to kernel bug. This leads to degraded
      # IPv6 performance in some situations.
      # checkReversePath = config.boot.kernelPackages.kernelAtLeast "5.16";
      checkReversePath = mkForce false; # Don't filter DHCP packets, according to nixops-libvirtd
    };
  };
}
