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

        extraApps = let
          inherit (config.services.nextcloud.package.packages) apps;
        in {
          # wtf is this formatting
          inherit (apps) mail polls onlyoffice contacts calendar tasks bookmarks deck forms cookbook impersonate groupfolders;
        };

        autoUpdateApps = {
          enable = true;
          startAt = "03:00";
        };

        caching = {
          apcu = true;
          memcached = true;
          redis = true;
        };

        config = {
          # admin user settings
          # only effective during setup
          adminuser = "notashelf";
          adminpassFile = config.age.secrets.nextcloud-secret.path;

          # database
          dbtype = "pgsql";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          dbuser = "nextcloud";
        };

        settings = {
          "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
          "memories.vod.ffmpeg" = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
          "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";

          # be very specific about the preview providers
          enabledPreviewProviders = [
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\MP3"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
            "OC\\Preview\\HEIC"
          ];

          # run maintenance jobs at low-load hours
          # i.e. 01:00am UTC and 05:00am UTC
          maintenance_window_start = 1;

          # force https
          overwriteprotocol = "https";
          trusted_domains = ["https://${toString domain}"];
          trusted_proxies = ["https://${toString domain}"];

          redis = {
            host = "/run/redis-default/redis.sock";
            dbindex = 0;
            timeout = 3;
          };

          # other stuff
          default_phone_region = "TR";
          lost_password_link = "disabled";
        };

        phpOptions = {
          "opcache.enable" = "1";
          "opcache.enable_cli" = "1";
          "opcache.jit" = "1255";
          "opcache.jit_buffer_size" = "256M";
          "opcache.validate_timestamps" = "0";
          "opcache.save_comments" = "1";

          # fix the opcache "buffer is almost full" error in admin overview
          "opcache.interned_strings_buffer" = "16";
          # try to resolve delays in displaying content or incomplete page rendering
          "output_buffering" = "off";

          "pm" = "dynamic";
          "pm.max_children" = "50";
          "pm.start_servers" = "15";
          "pm.min_spare_servers" = "15";
          "pm.max_spare_servers" = "25";
          "pm.max_requests" = "500";
        };

        phpExtraExtensions = ext: [ext.redis];
      };

      nginx.virtualHosts."cloud.notashelf.dev" =
        {
          quic = true;
          http3 = true;
        }
        // lib.sslTemplate;
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
