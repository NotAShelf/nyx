{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  domain = "cloud.notashelf.dev";

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.nextcloud.enable {
    modules.system.services = {
      nginx.enable = true;
      database = {
        redis.enable = true;
        postgresql.enable = true;
      };
    };

    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;

        nginx.recommendedHttpHeaders = true;
        https = true;
        hostName = domain;

        home = "/srv/storage/nextcloud";
        maxUploadSize = "4G";
        enableImagemagick = true;

        extraApps = with config.services.nextcloud.package.packages.apps; {
          # wtf is this formatting
          inherit
            #news
            contacts
            calendar
            tasks
            bookmarks
            deck
            forms
            ;
        };

        autoUpdateApps = {
          enable = true;
          startAt = "03:00";
        };

        config = {
          # admin user settings
          # only effective during setup
          adminuser = "notashelf";
          adminpassFile = config.age.secrets.nextcloud-secret.path;

          # force https
          overwriteProtocol = "https";
          extraTrustedDomains = ["https://${toString domain}"];
          trustedProxies = ["https://${toString domain}"];

          # database
          dbtype = "pgsql";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";

          # other stuff
          defaultPhoneRegion = "TR";
        };

        phpOptions = {
          # fix the opcache "buffer is almost full" error in admin overview
          "opcache.interned_strings_buffer" = "16";
        };

        caching = {
          apcu = true;
          memcached = true;
          redis = true;
        };

        extraOptions = {
          redis = {
            host = "/run/redis-default/redis.sock";
            dbindex = 0;
            timeout = 3;
          };
        };
      };

      nginx.virtualHosts."cloud.notashelf.dev" = lib.sslTemplate;
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

      /*
      "nextcloud-preview" = {
        description = "Generate previews for all images that haven't been rendered";
        startAt = "01:00:00";
        requires = ["nextcloud.service"];
        after = ["nextcloud.service"];
        path = [config.services.nextcloud.occ];
        script = "nextcloud-occ preview:generate";

        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
      */
    };
  };
}
