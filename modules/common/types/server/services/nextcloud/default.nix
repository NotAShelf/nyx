{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib; let
  domain = "cloud.notashelf.dev";

  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice config acceptedTypes) && config.modules.services.nextcloud.enable) {
    age.secrets.nextcloud-auth = {
      file = "${self}/secrets/nextcloud-secret.age";
      owner = "nextcloud";
    };
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        caching.redis = true;
        extraOptions = {
          redis = {
            host = "/run/redis-default/redis.sock";
            dbindex = 0;
            timeout = 1.5;
          };
        };
        hostName = "cloud.notashelf.dev";
        home = "/opt/nextcloud";
        maxUploadSize = "4G";
        enableImagemagick = true;

        autoUpdateApps = {
          enable = true;
          startAt = "02:00";
        };

        config = {
          overwriteProtocol = "https";
          extraTrustedDomains = ["https://${toString domain}"];
          trustedProxies = ["https://${toString domain}"];
          adminuser = "notashelf";
          adminpassFile = config.age.secrets.nextcloud-secret.path;
          dbtype = "pgsql";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          defaultPhoneRegion = "TR";
        };
        nginx.recommendedHttpHeaders = true;
        https = true;
      };

      # database service
      postgresql = {
        enable = mkForce true;
        ensureDatabases = [config.services.nextcloud.config.dbname];
        ensureUsers = [
          {
            name = config.services.nextcloud.config.dbuser;
            ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
          }
        ];
      };
    };
    systemd.services = {
      phpfpm-nextcloud.aliases = ["nextcloud.service"];
      "nextcloud-setup" = {
        requires = ["postgresql.service"];
        after = ["postgresql.service"];
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
  };
}
