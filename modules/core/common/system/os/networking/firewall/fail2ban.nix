{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge concatStringsSep mkForce;

  sys = config.modules.system;
in {
  # fail2ban firewall jail
  services.fail2ban = {
    enable = true;
    banaction = "iptables-multiport[blocktype=DROP]";
    maxretry = 7;
    ignoreIP = [
      "127.0.0.0/8" # localhost
      "10.0.0.0/8" # wireguard
      "100.64.0.0/16" # tailscake
      "192.168.0.0/16" # local network
    ];

    jails = mkMerge [
      {
        # sshd jail
        sshd = mkForce ''
          enabled = true
          port = ${concatStringsSep "," (map toString config.services.openssh.ports)}
          mode = aggressive
        '';
      }
      (mkIf sys.services.vaultwarden.enable {
        # vaultwarden and vaultwarden admin interface jails
        vaultwarden = ''
          enabled = true
          port = 80,443,8822
          filter = vaultwarden
          banaction = %(banaction_allports)s
          logpath = /var/log/vaultwarden.log
          maxretry = 3
          bantime = 14400
          findtime = 14400
        '';

        vaultwarden-admin = ''
          enabled = true
          port = 80,443
          filter = vaultwarden-admin
          banaction = %(banaction_allports)s
          logpath = /var/log/vaultwarden.log
          maxretry = 3
          bantime = 14400
          findtime = 14400
        '';
      })
    ];

    bantime-increment = {
      enable = true;
      rndtime = "12m";
      overalljails = true;
      multipliers = "4 8 16 32 64 128 256 512 1024 2048";
      maxtime = "5000h"; # get banned for 5000 hours idiot
    };
  };
}
