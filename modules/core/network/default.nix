{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ssh.nix
    ./blocker.nix
    ./tcp.nix
  ];

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

    firewall = {
      enable = true;
      allowedTCPPorts = [443 80 22 8080];
      allowedUDPPorts = [443 80 9100 44857 8080];
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  # enable opensnitch firewall
  services.opensnitch.enable = true;

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
  # enable wireless database
  hardware.wirelessRegulatoryDatabase = true;
}
