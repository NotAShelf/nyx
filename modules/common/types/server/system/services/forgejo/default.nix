{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  cfg = config.modules.system.services;
  domain = "git.notashelf.dev";
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.forgejo.enable) {
    networking.firewall.allowedTCPPorts = [
      # make sure the service is reachable from outside
      config.services.forgejo.settings.server.HTTP_PORT
      config.services.forgejo.settings.server.SSH_PORT
    ];

    modules.system.services.database = {
      redis.enable = true;
      postgresql.enable = true;
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

          ui.DEFAULT_THEME = "arc-green";

          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
          };

          server = {
            HTTP_PORT = 7000;
            ROOT_URL = "https://${domain}";
            DOMAIN = "${domain}";
            DISABLE_ROUTER_LOG = true;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            LANDING_PAGE = "/explore/repos";

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

          mailer = {
            ENABLED = true;
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.notashelf.dev";
            USER = "git@notashelf.dev";
          };

          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          packages.ENABLED = false;
          repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
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
    };
  };
}
