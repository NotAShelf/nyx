{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  cfg = config.modules.services;
  domain = "git.notashelf.dev";
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.forgejo.enable) {
    networking.firewall.allowedTCPPorts = [config.services.forgejo.settings.server.HTTP_PORT];

    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        lfs.enable = true;
        user = "git";
        group = "git";
        database.user = "git";
        stateDir = "/srv/storage/forgejo/data";

        mailerPasswordFile = config.age.secrets.mailserver-forgejo-secret.path;

        dump = {
          enable = true;
          backupDir = "/srv/storage/forgejo/dump";
          interval = "06:00";
          type = "tar.zst";
        };

        settings = {
          server = {
            ROOT_URL = "https://${domain}";
            HTTP_PORT = 7000;
            DOMAIN = "${domain}";

            START_SSH_SERVER = false;
            BUILTIN_SSH_SERVER_USER = "git";
            SSH_PORT = 30;
            DISABLE_ROUTER_LOG = true;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            LANDING_PAGE = "/explore/repos";
          };

          default.APP_NAME = "The Secret Shelf";
          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          ui.DEFAULT_THEME = "arc-green";
          migrations.ALLOWED_DOMAINS = "github.com, *.github.com, gitlab.com, *.gitlab.com";
          packages.ENABLED = false;
          repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";

          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };

          mailer = {
            ENABLED = true;
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.notashelf.dev";
            USER = "git@notashelf.dev";
          };
        };
      };

      openssh = {
        extraConfig = ''
          Match User git
            AuthorizedKeysCommandUser git
            AuthorizedKeysCommand ${lib.getExe pkgs.forgejo} keys -e git -u %u -t %t -k %k
          Match all
        '';
      };
    };
  };
}
