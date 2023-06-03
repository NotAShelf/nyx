{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib; let
  domain = "cloud.notashelf.dev";

  device = config.modules.device;
  cfg = config.modules.services.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes && !cfg.nextcloud) {
    age.secrets.nextcloud-auth = {
      file = "${self}/secrets/nextcloud-secret.age";
      owner = "nextcloud";
    };
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud26;
        hostName = "cloud.notashelf.dev";
        home = "/opt/nextcloud";
        autoUpdateApps.enable = true;
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
      postgresql = {
        enable = true;
        ensureDatabases = [config.services.nextcloud.config.dbname];
        ensureUsers = [
          {
            name = config.services.nextcloud.config.dbuser;
            ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
          }
        ];
      };
    };
    systemd.services."nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };
  };
}
