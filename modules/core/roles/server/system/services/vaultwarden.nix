{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
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
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.vaultwarden.settings.port;
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
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
            extraConfig = "proxy_pass_header Authorization;";
          };
        }
        // lib.sslTemplate;
    };
  };
}
