{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;

  cfg = config.modules.system.services;
  domain = "git.notashelf.dev";

  dataDir = "/srv/storage/forgejo";
  dumpDir = "/srv/storage/forgejo-dump";

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

    networking.firewall.allowedTCPPorts = [2222];

    systemd.tmpfiles.rules = let
      # Disallow crawlers from indexing this site.
      robots = pkgs.writeText "forgejo-robots-txt" ''
        User-agent: *
        Disallow: /
      '';
    in [
      "L+ ${config.services.forgejo.customDir}/public/robots.txt - - - - ${robots.outPath}"
    ];

    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo.override {pamSupport = false;};
        stateDir = dataDir;
        database.type = "postgres";

        # This was mailerPasswordFile before 24.11
        secrets.mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
        lfs.enable = true;

        # <https://forgejo.org/docs/latest/admin/config-cheat-sheet>
        settings = {
          DEFAULT.APP_NAME = "The Secret Shelf";
          badges.ENABLED = true;

          database = {
            DB_TYPE = "postgres";

            # If DB_TYPE is postgres
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

          ui = {
            DEFAULT_THEME = "forgejo-dark";
            EXPLORE_PAGING_NUM = 5;
            SHOW_USER_EMAIL = false; # hide user email in the explore page
            GRAPH_MAX_COMMIT_NUM = 200;
          };

          "ui.meta" = {
            AUTHOR = "NotAShelf's Private Git Instance";
            DESCRIPTION = ''
              NotAShelf's private Git instance for software that sucks more.
            '';
          };

          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          packages.ENABLED = false;
          log.LEVEL = "Debug";

          repository = {
            DISABLE_STARS = true; # I'm alone on here...

            PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
            ENABLE_PUSH_CREATE_USER = true;

            DEFAULT_PRIVATE = "public";
            DEFAULT_PRIVATE_PUSH_CREATE = true;
            DEFAULT_MERGE_STYLE = "rebase-merge";
            DEFAULT_REPO_UNITS = "repo.code, repo.issues, repo.pulls, repo.actions";
          };

          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };

          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
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
            LOGIN_REMEMBER_DAYS = 7;
          };

          server = {
            PROTOCOL = "http+unix"; # unix socket is used by Nginx, deefault is "http"
            HTTP_PORT = port;
            ROOT_URL = "https://${domain}";
            DOMAIN = "${domain}";
            DISABLE_ROUTER_LOG = true;
            LANDING_PAGE = "/explore";

            # Internal SSH server configuration
            START_SSH_SERVER = true;
            SSH_PORT = 2222;
            SSH_LISTEN_PORT = 2222;
          };

          "repository.pull_request" = {
            WORK_IN_PROGRESS_PREFIXES = "WIP:,[WIP],DRAFT,[DRAFT]";
            ADD_CO_COMMITTERS_TRAILERS = true;
          };

          "git.timeout" = {
            DEFAULT = 3600;
            MIGRATE = 3600;
            MIRROR = 3600;
            CLONE = 3600;
          };

          "markup.asciidoc" = {
            ENABLED = true;
            NEED_POSTPROCESS = true;
            FILE_EXTENSIONS = ".adoc,.asciidoc";
            RENDER_COMMAND = "${pkgs.asciidoctor}/bin/asciidoctor --embedded --out-file=- -";
            IS_INPUT_FILE = false;
          };

          session = {
            PROVIDER = "redis";
            PROVIDER_CONFIG = "redis://:forgejo@localhost:6371";
          };

          mailer = mkIf config.modules.system.services.mailserver.enable {
            ENABLED = true;
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.notashelf.dev";
            SMTP_PORT = 465;
            FROM = "Forgejo <forgejo@notashelf.dev>";
            USER = "forgejo@notashelf.dev";
            SEND_AS_PLAIN_TEXT = true;
            SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
          };

          federation = {
            ENABLED = true;
          };

          metrics = {
            ENABLED = true;
            ENABLED_ISSUE_BY_REPOSITORY = true;
            ENABLED_ISSUE_BY_LABEL = true;
          };
        };

        # backup
        dump = {
          enable = true;
          backupDir = dumpDir;
          interval = "06:00";
          type = "tar.zst";
        };
      };

      nginx.virtualHosts."${domain}" =
        {
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "http://unix:/run/forgejo/forgejo.sock";
          };

          quic = true;
        }
        // lib.sslTemplate;

      fail2ban.jails.forgejo = {
        settings = {
          filter = "forgejo";
          action = "nftables-multiport";
          mode = "aggressive";
          maxretry = 3;
          findtime = 3600;
          bantime = 900;
        };
      };
    };

    environment.etc = {
      "fail2ban/filter.d/forgejo.conf".text = ''
        [Definition]
        failregex = ^.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>$
        journalmatch = _SYSTEMD_UNIT=forgejo.service
      '';
    };
  };
}
