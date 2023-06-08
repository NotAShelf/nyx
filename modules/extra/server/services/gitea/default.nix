{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  cfg = config.modules.services.override;
  domain = "git.notashelf.dev";
in {
  # TODO: add gitea service override
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.gitea)) {
    networking.firewall.allowedTCPPorts = [config.services.gitea.settings.server.HTTP_PORT];

    services = {
      gitea = {
        enable = true;
        package = pkgs.forgejo;
        appName = "The Secret Shelf";
        lfs.enable = true;
        user = "git";
        database.user = "git";
        stateDir = "/srv/gitea/data";

        mailerPasswordFile = config.age.secrets.mailserver-gitea-secret;
        dump = {
          enable = true;
          backupDir = "/srv/gitea/dump";
          interval = "06:00";
          type = "tar.zst";
        };

        settings = {
          migrations = {
            ALLOWED_DOMAINS = "github.com, *.github.com, gitlab.com, *.gitlab.com";
          };

          packages = {
            ENABLED = false;
          };

          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };

          repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";

          mailer = {
            ENABLED = true;
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.notashelf.dev";
            USER = "gitea@notashelf.dev";
          };

          server = {
            ROOT_URL = "https://${domain}";
            HTTP_PORT = 7000;
            DOMAIN = "${domain}";

            START_SSH_SERVER = false;
            BUILTIN_SSH_SERVER_USER = "git";
            SSH_PORT = 22;
            DISABLE_ROUTER_LOG = true;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            LANDING_PAGE = "/explore/repos";
          };

          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          ui.DEFAULT_THEME = "arc-green";
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
