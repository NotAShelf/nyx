{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.vaultwarden.settings) port host;
in {
  config = mkIf cfg.vaultwarden.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    # this forces the system to create backup folder
    systemd.services.backup-vaultwarden.serviceConfig = {
      User = "root";
      Group = "root";
    };

    services = {
      vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwarden-env.path;
        backupDir = "/srv/storage/vaultwarden/backup";
        config = {
          DOMAIN = "https://vault.notashelf.dev";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = host;
          ROCKET_PORT = port;
          extendedLogging = true;
          invitationsAllowed = false;
          useSyslog = true;
          logLevel = "warn";
          showPasswordHint = false;
          signupsAllowed = false;
          signupsDomainsWhitelist = "notashelf.dev";
          signupsVerify = true;
          smtpAuthMechanism = "Login";
          smtpFrom = "vaultwarden@notashelf.dev";
          smtpFromName = "NotAShelf's Vaultwarden Service";
          smtpHost = "mail.notashelf.dev";
          smtpPort = 465;
          smtpSecurity = "force_tls";
          dataDir = "/srv/storage/vaultwarden";
        };
      };

      nginx.virtualHosts."vault.notashelf.dev" =
        {
          locations."/" = {
            proxyPass = "http://${host}:${toString port}";
            extraConfig = "proxy_pass_header Authorization;";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
