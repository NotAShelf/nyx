{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./ssh.nix
    ./blocker.nix
  ];

  services = {
    # systemd DNS resolver daemon
    resolved.enable = true;

    # enable opensnitch firewall
    opensnitch.enable = true;
    
    # fail2ban firewall jail
    fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];
  };

  };

  networking = {
    hostId = builtins.substring 0 8 (
      builtins.hashString "md5" config.networking.hostName
    );

    # dns
    nameservers = ["1.1.1.1" "1.0.0.1"];

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };

    nftables.enable = false;
    firewall = {
      enable = mkDefault false;
      package = mkDefault pkgs.iptables;
      allowedTCPPorts = [443 80 22 8080 3030];
      allowedUDPPorts = [443 80 9100 44857 8080];
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
  # enable wireless database
  hardware.wirelessRegulatoryDatabase = true;
}
