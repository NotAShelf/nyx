{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  # cfg = config.modules.programs.override;
  domain = "git.notashelf.dev";
in {
  # TODO: add gitea service override
  config = mkIf (builtins.elem device.type acceptedTypes) {
    systemd.services.gitea.serviceConfig.SystemCallFilter =
      lib.mkForce
      "~@clock @cpu-emulation @debug @keyring @memlock @module @obsolete @raw-io @reboot @resources @setuid @swap";

    services = {
      gitea = {
        enable = false;
        package = pkgs.forgejo;
        lfs.enable = true;

        user = "git";
        database.user = "git";

        appName = "The Secret Shelf";
        domain = "${domain}";
        rootUrl = "https://${domain}";
        httpPort = 7000;
        settings = {
          repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
          server = {
            START_SSH_SERVER = false;
            BUILTIN_SSH_SERVER_USER = "git";
            SSH_PORT = 22;
            DISABLE_ROUTER_LOG = true;
            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
          };
          attachment.ALLOWED_TYPES = "*/*";
          service.DISABLE_REGISTRATION = true;
          ui.DEFAULT_THEME = "arc-green";
        };
      };

      nginx = {
        virtualHosts = {
          "${domain}" = {
            addSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.gitea.httpPort}/";
            };
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
