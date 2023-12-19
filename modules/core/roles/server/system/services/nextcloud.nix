{
  config,
  lib,
  self,
  pkgs,
  ...
}:
with lib; let
  domain = "cloud.notashelf.dev";

  dev = config.modules.device;
  cfg = config.modules.system.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.nextcloud.enable) {
    age.secrets.nextcloud-auth = {
      file = "${self}/secrets/nextcloud-secret.age";
      owner = "nextcloud";
    };

    modules.system.services.database = {
      redis.enable = true;
      postgresql.enable = true;
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
          startAt = "02:00";
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
            timeout = 1.5;
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

      "nextcloud-preview" = {
        description = "Generate previews for all images that haven't been rendered";
        startAt = "01:00:00";
        path = [config.services.nextcloud.occ];
        script = ''
          nextcloud-occ preview:pre-generate
        '';
      };
    };
  };
}
