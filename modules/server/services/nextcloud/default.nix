{
  config,
  lib,
  ...
}:
with lib; let
  domain = "cloud.notashelf.dev";

  device = config.modules.device;
  #cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = {
    services.nextcloud = {
      enable = false;
      package = pkgs.nextcloud26;
      hostName = domain;
      nginx.recommendedHttpHeaders = true;
      enableBrokenCiphersForSSE = false;
      https = true;
      autoUpdateApps.enable = true;
      config = {
        dbtype = "pgsql";
        dbhost = "/run/postgresql";
        dbpassFile = config.age.secrets.nextcloud-db-pass.path;
        adminpassFile = config.age.secrets.nextcloud-admin-root-pass.path;
        adminuser = "admin-root";
        defaultPhoneRegion = "IL";
      };
    };

    services.postgresql = {
      enable = false;
      ensureDatabases = [config.services.nextcloud.config.dbname];
      ensureUsers = [
        {
          name = config.services.nextcloud.config.dbuser;
          ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
        }
      ];
    };

    # Ensure nextcloud does not start before its database
    systemd.services."nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };

    services.nginx = {
      enable = true;
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
      };
    };

    /*
    age.secrets = {
      nextcloud-db-pass = {
        file = "${inputs.self}/secrets/nextcloud-db-pass.age";
        group = "nextcloud";
        owner = "nextcloud";
      };
      nextcloud-admin-root-pass = {
        file = "${inputs.self}/secrets/nextcloud-admin-root-pass.age";
        group = "nextcloud";
        owner = "nextcloud";
      };
    };
    */
  };
}
