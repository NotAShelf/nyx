{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) concatStringsSep;

  sys = config.modules.system;
in {
  # fail2ban firewall jail
  services.fail2ban = {
    enable = true;
    extraPackages = with pkgs; [nftables ipset]; # make nftables accessible to fail2ban service

    ignoreIP = [
      "127.0.0.0/8" # localhost
      "10.0.0.0/8" # wireguard
      "100.64.0.0/16" # tailscale
      "192.168.0.0/16" # local network
    ];

    banaction = "nftables-multiport";
    banaction-allports = lib.mkDefault "nftables-allport";

    maxretry = 7;
    bantime = "10m";
    bantime-increment = {
      enable = true;
      rndtime = "12m";
      overalljails = true;
      multipliers = "4 8 16 32 64 128 256 512 1024 2048";
      maxtime = "5000h"; # get banned for 5000 hours idiot
    };

    daemonSettings = {
      Definition = {
        loglevel = "INFO";
        logtarget = "/var/log/fail2ban/fail2ban.log";
        socket = "/run/fail2ban/fail2ban.sock";
        pidfile = "/run/fail2ban/fail2ban.pid";
        dbfile = "/var/lib/fail2ban/fail2ban.sqlite3";
        dbpurageage = "1d";
      };
    };
  };
}
