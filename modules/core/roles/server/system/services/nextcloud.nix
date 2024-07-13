{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

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

    users.users.nextcloud = {
      extraGroups = ["render"]; # access /dev/dri/renderD128
      packages = [pkgs.ffmpeg-headless];
    };

    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud29;

        https = true;
        hostName = domain;
        nginx.recommendedHttpHeaders = true;

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
          "memories.exiftool" = getExe pkgs.exiftool;
          "memories.vod.vaapi" = true;
          "memories.vod.ffmpeg" = getExe pkgs.ffmpeg-headless;
          "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";

          jpeg_quality = 60;
          preview_max_filesize_image = 128; # MB
          preview_max_memory = 512; # MB
          preview_max_x = 2048; # px
          preview_max_y = 2048; # px

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

            # <https://github.com/nextcloud/server/tree/master/lib/private/Preview>
            ''OC\Preview\Font''
            ''OC\Preview\PDF''
            ''OC\Preview\SVG''
            ''OC\Preview\WebP''
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
          "opcache.validate_timestamps" = "0";
          "opcache.save_comments" = "1";

          # <https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html>
          "opcache.jit" = "1255";
          "opcache.jit_buffer_size" = "256M";

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
