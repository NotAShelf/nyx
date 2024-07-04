{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;

  sys = config.modules.system;
  cfg = sys.services;

  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;

  dataDir = "/srv/storage/vaultwarden";
  backupDir = "/srv/storage/bitwarden-backup";

  inherit (cfg.vaultwarden.settings) port host;
in {
  config = mkIf cfg.vaultwarden.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    systemd.tmpfiles.settings = {
      "10-vaultwarden" = {
        "${dataDir}" = {
          d = {
            inherit user group;
            mode = "0700";
          };
        };

        "${backupDir}" = {
          d = {
            inherit user group;
            mode = mkForce "0750";
            age = "30d";
          };
        };
      };
    };

    services = {
      vaultwarden = {
        enable = true;
        inherit backupDir;

        # Sensitive configuration options go here
        environmentFile = config.age.secrets.vaultwarden-env.path;

        config = {
          DATA_FOLDER = dataDir;
          ATTACHMENTS_FOLDER = "${dataDir}/attachments";
          ICON_CACHE_FOLDER = "${dataDir}/icon_cache";

          DOMAIN = "https://vault.notashelf.dev";

          # Rocket server configuration
          ROCKET_ADDRESS = host;
          ROCKET_PORT = port;
          ROCKET_LIMITS = "{json=10485760}"; # 10MB limit for posted json in the body

          # No password hint
          SHOW_PASSWORD_HINT = false;

          # Log to system journal
          extendedLogging = true;
          EXTENDED_LOGGING = true;
          USE_SYSLOG = true;
          LOG_LEVEL = "warn";

          # Only allow signups from my own domain
          # or the admin panel.
          INVITATIONS_ALLOWED = false;

          SIGNUPS_ALLOWED = false;
          SIGNUPS_VERIFY = true;
          SIGNUPS_DOMAINS_WHITELIST = "notashelf.dev";

          # Push notifications
          PUSH_ENABLED = true;
          PUSH_RELAY_URI = "https://api.bitwarden.eu";
          PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";

          # SMTP Settings
          smtpAuthMechanism = "Login";
          smtpFrom = "vaultwarden@notashelf.dev";
          smtpFromName = "NotAShelf's Vaultwarden Service";
          smtpHost = "mail.notashelf.dev";
          smtpPort = 465;
          smtpSecurity = "force_tls";
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

      fail2ban.jails = {
        vaultwarden-web = {
          filter = {
            INCLUDES.before = "common.conf";
            Definition = {
              failregex = "^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$";
              ignoreregex = "";
            };
          };

          settings = {
            backend = "systemd";
            port = "80,443,8222";
            filter = "vaultwarden-web[journalmatch='_SYSTEMD_UNIT=vaultwarden.service']";
            banaction = "%(banaction_allports)s";
            maxretry = 3;
            bantime = 14400;
            findtime = 14400;
          };
        };

        vaultwarden-admin = {
          filter = {
            INCLUDES.before = "common.conf";
            Definition = {
              failregex = "^.*Invalid admin token\. IP: <ADDR>.*$";
              ignoreregex = "";
            };
          };

          settings = {
            backend = "systemd";
            port = "80,443,8222";
            filter = "vaultwarden-admin[journalmatch='_SYSTEMD_UNIT=vaultwarden.service']";
            banaction = "%(banaction_allports)s";
            maxretry = 3;
            bantime = 14400;
            findtime = 14400;
          };
        };
      };
    };

    systemd.services = {
      vaultwarden.serviceConfig = {
        ReadWriteDirectories = dataDir;
      };

      backup-vaultwarden = {
        environment.DATA_FOLDER = mkForce dataDir;
        serviceConfig = {
          ReadWriteDirectories = dataDir;
        };
      };
    };
  };
}
