{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.system.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.mastodon.enable) {
    services = {
      elasticsearch.enable = true;
      postgresql.enable = true;

      mastodon = {
        enable = true;
        user = "mastodon";
        configureNginx = true;
        localDomain = "social.notashelf.dev";

        redis = {
          createLocally = false;
          host = "localhost";
          port = 6372;
        };

        # configure smtp
        smtp = {
          authenticate = true;
          createLocally = false;
          fromAddress = "noreply@notashelf.dev";
          user = "noreply";
          host = "mail.notashelf.dev";
          passwordFile = config.age.secrets.mailserver-noreply-secret.path;
        };

        # extra config
        extraConfig = {
          SINGLE_USER_MODE = "true";
          WEB_DOMAIN = "social.notashelf.dev";
        };
      };
    };
  };
}
