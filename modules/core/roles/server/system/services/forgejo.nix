{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system.services;
  domain = "git.notashelf.dev";

  inherit (cfg.forgejo.settings) port;
in {
  config = mkIf cfg.forgejo.enable {
    modules.system.services = {
      nginx.enable = true;
      database = {
        redis.enable = true;
        postgresql.enable = true;
      };
    };

    networking.firewall.allowedTCPPorts = [
      # make sure the service is reachable from outside
      config.services.forgejo.settings.server.HTTP_PORT
      config.services.forgejo.settings.server.SSH_PORT
    ];

    users = {
      users.git = {
        isSystemUser = true;
        createHome = false;
        group = "git";
      };

      groups.git = {};
    };

    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        stateDir = "/srv/storage/forgejo/data";

        mailerPasswordFile = config.age.secrets.mailserver-forgejo-secret.path;
        lfs.enable = true;

        settings = {
          default.APP_NAME = "The Secret Shelf";

          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://git.notashelf.dev";
          };

          other = {
            SHOW_FOOTER_VERSION = false;
            SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
          };

          session = {
            COOKIE_SECURE = true;
            SAME_SITE = "strict";
          };

          server = {
            PROTOCOL = "http+unix";
            HTTP_PORT = port;
            ROOT_URL = "https://${domain}";
            DOMAIN = "${domain}";
            DISABLE_ROUTER_LOG = true;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            LANDING_PAGE = "/explore";

            START_SSH_SERVER = true;
            SSH_PORT = 2222;
            SSH_LISTEN_PORT = 2222;
          };

          database = {
            DB_TYPE = lib.mkForce "postgres";
            HOST = "/run/postgresql";
            NAME = "forgejo";
            USER = "forgejo";
            PASSWD = "forgejo";
          };

          cache = {
            ENABLED = true;
            ADAPTER = "redis";
            HOST = "redis://:forgejo@localhost:6371";
          };

          mailer = mkIf config.modules.system.services.mailserver.enable {
            ENABLED = true;
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.notashelf.dev";
            USER = "git@notashelf.dev";
          };

          ui.DEFAULT_THEME = "arc-green";
          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          packages.ENABLED = false;
          repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
          log.LEVEL = "Debug";
          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };
        };

        # backup
        dump = {
          enable = true;
          backupDir = "/srv/storage/forgejo/dump";
          interval = "06:00";
          type = "tar.zst";
        };
      };

      nginx.virtualHosts."git.notashelf.dev" =
        {
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "http://unix:/run/forgejo/forgejo.sock";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
