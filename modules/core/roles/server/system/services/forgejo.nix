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

    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo.override {pamSupport = false;};
        stateDir = "/srv/storage/forgejo/data";

        mailerPasswordFile = config.age.secrets.mailserver-forgejo-secret.path;
        lfs.enable = true;

        # https://forgejo.org/docs/latest/admin/config-cheat-sheet/
        settings = {
          default.APP_NAME = "The Secret Shelf";
          badges.ENABLED = true;

          ui = {
            DEFAULT_THEME = "forgejo-dark";
            EXPLORE_PAGING_NUM = 5;
            SHOW_USER_EMAIL = false; # hide user email in the explore page
          };

          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          packages.ENABLED = false;
          log.LEVEL = "Debug";

          repository = {
            DISABLE_STARS = true;
            PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
          };

          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };

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

          security = {
            INSTALL_LOCK = true;
            PASSWORD_CHECK_PWN = true;
            PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
          };

          server = {
            PROTOCOL = "http+unix";
            HTTP_PORT = port;
            ROOT_URL = "https://${domain}";
            DOMAIN = "${domain}";
            DISABLE_ROUTER_LOG = true;
            LANDING_PAGE = "/explore";

            START_SSH_SERVER = true;
            SSH_PORT = 2222;
            SSH_LISTEN_PORT = 2222;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            BUILTIN_SSH_SERVER_USER = "git";
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
