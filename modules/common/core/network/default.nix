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
    ./tailscale.nix
  ];

  services = {
    # systemd DNS resolver daemon
    resolved.enable = true;
  };

  networking = {
    hostId = builtins.substring 0 8 (
      builtins.hashString "md5" config.networking.hostName
    );

    # dns
    nameservers = ["1.1.1.1" "1.0.0.1"];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };
  };

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
  # enable wireless database
  hardware.wirelessRegulatoryDatabase = true;
}
