{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.modules) mkIf mkDefault mkForce;
  inherit (lib.strings) fileContents;
  inherit (lib.attrsets) mapAttrs;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (config.networking) domain;
in {
  config = mkIf cfg.nginx.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "me@notashelf.dev";
      };
    };

    services = {
      nginx = {
        enable = true;
        package = pkgs.nginxQuic.override {withKTLS = true;};

        # makes /nginx_status endpoint available t o localhost
        statusPage = true;

        recommendedTlsSettings = true;
        recommendedBrotliSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        recommendedZstdSettings = true;

        clientMaxBodySize = mkDefault "512m";
        serverNamesHashBucketSize = 1024;
        appendHttpConfig = ''
          # set the maximum size of the headers hash tables to 1024 bytes
          # this applies to the total size of all headers in a client request
          # or a server response.
          proxy_headers_hash_max_size 1024;

          # set the bucket size for the headers hash tables to 256 bytes
          #  bucket size determines how many entries can be stored in
          # each hash table bucket
          proxy_headers_hash_bucket_size 256;
        '';

        # lets be more picky on our ciphers and protocols
        sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
        sslProtocols = "TLSv1.3 TLSv1.2";

        commonHttpConfig = ''
          # map the scheme (HTTP or HTTPS) to the HSTS header for HTTPS
          # the header includes max-age, includeSubdomains and preload
          map $scheme $hsts_header {
            https "max-age=31536000; includeSubdomains; preload";
          }

          # add the Referrer-Policy header with a value of "no-referrer"
          # which instructs the browser not to send the 'Referer' header in
          # subsequent requests
          add_header "Referrer-Policy" "no-referrer";

          # adds the Strict-Transport-Security header with a value derived from the mapped HSTS header
          # which instructs the browser to always use HTTPS instead of HTTP
          add_header Strict-Transport-Security $hsts_header;

          # sets the path for cookies to "/", and adds attributes "secure", "HttpOnly", and "SameSite=strict"
          #  "secure": ensures that the cookie is only sent over HTTPS
          #  "HttpOnly":  prevents the cookie from being accessed by JavaScript
          #  "SameSite=strict": restricts the cookie to be sent only in requests originating from the same site
          proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

          # define a new map that anonymizes the remote address
          # by replacing the last octet of IPv4 addresses with 0
          map $remote_addr $remote_addr_anon {
            ~(?P<ip>\d+\.\d+\.\d+)\.    $ip.0;
            ~(?P<ip>[^:]+:[^:]+):       $ip::;
            default                     0.0.0.0;
          }

          # define a new log format that anonymizes the remote address
          # and adds the remote user name, the time, the request line,
          log_format combined_anon '$remote_addr_anon - $remote_user [$time_local] '
                                   '"$request" $status $body_bytes_sent '
                                   '"$http_referer" "$http_user_agent"';

          # write the access log to a file with the combined_anon format
          # and a buffer size of 32k, flushing every 5 minutes
          access_log /var/log/nginx/access.log combined_anon buffer=32k flush=5m;

          # define a new log format that anonymizes the remote address
          # and adds remote user name, local time, the request line and http3
          # this is important for debugging quic enabled requests
          log_format quic '$remote_addr_anon - $remote_user [$time_local] '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent" "$http3"';

          # write the access log to a file with the quic format
          access_log /var/log/nginx/quic-access.log quic;

          # error log should log only "warn" level and above
          error_log /var/log/nginx/error.log warn;
        '';

        virtualHosts = {
          /*
          # FIXME: this conflicts with the cache server
          "_" = {
            default = true;
            locations."/".return = "404";
          };
          */

          "${domain}" = {
            default = true;
            serverAliases = ["www.${domain}"];

            locations = let
              commonConfig = ''
                try_files $uri $uri/ =404;

                default_type text/plain;
                charset utf-8;
              '';

              # takes a path to a file and returns a
              # configuration for a location that serves that file
              mkStaticPage = {
                name,
                root,
                header ? "",
                footer ? "",
              }: let
                builtIndex = pkgs.writeTextDir "${name}" ''
                  ${header}
                  ${fileContents root}
                  ${footer}
                '';
              in {
                index = name;
                root = builtIndex.outPath;
                extraConfig = commonConfig;
              };
            in {
              # root location
              "/" = mkStaticPage {
                root = ./static/root.txt;
                name = "root.txt";
                header = readFile ./static/header.txt;
                footer = "> served by ${pkgs.nginx.outPath}";
              };

              # /gpg endpoint for my gpg key
              "/gpg" = mkStaticPage {
                name = "gpg.txt";
                root = ./static/gpg.txt;
              };
            };
          };
        };
      };

      fail2ban.jails = {
        nginx-bad-request.settings.enabled = true;
        nginx-http-auth.settings = {
          enabled = true;
          filter = "nginx-http-auth";
          action = ''nftables-multiport[name=NGINXAUTH, port="443", protocol=tcp]'';
        };

        nginx-botsearch.settings = {
          enabled = true;
          filter = "nginx-botsearch";
          action = ''nftables-multiport[name=NGINXBOT, port="443", protocol=tcp]'';
        };
      };

      # Periodically rotate the logs
      logrotate.settings.nginx = {
        enable = true;
        minsize = "50M";
        rotate = "4"; # 4 files of 50mb each
        compress = true;
      };
    };

    systemd.services.nginx.serviceConfig = mapAttrs (_: mkForce) {
      SupplementaryGroups = ["shadow"];
      NoNewPrivileges = false;
      PrivateDevices = false;
      ProtectHostname = false;
      ProtectKernelTunables = false;
      ProtectKernelModules = false;
      RestrictAddressFamilies = [];
      LockPersonality = false;
      MemoryDenyWriteExecute = false;
      RestrictRealtime = false;
      RestrictSUIDSGID = false;
      SystemCallArchitectures = "";
      ProtectClock = false;
      ProtectKernelLogs = false;
      RestrictNamespaces = false;
      SystemCallFilter = "";
    };
  };
}
