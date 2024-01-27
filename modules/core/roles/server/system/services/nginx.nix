{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;

  sys = config.modules.system;
  cfg = sys.services;
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
        package = pkgs.nginxQuic;
        recommendedTlsSettings = true;
        recommendedBrotliSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        recommendedZstdSettings = true;
        clientMaxBodySize = mkDefault "512m";
        serverNamesHashBucketSize = 1024;
        appendHttpConfig = ''
          proxy_headers_hash_max_size 1024;
          proxy_headers_hash_bucket_size 256;
        '';

        # lets be more picky on our ciphers and protocols
        sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
        sslProtocols = "TLSv1.3 TLSv1.2";

        commonHttpConfig = ''
          add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload' always;

          access_log  /var/log/nginx/access.log combined;
          error_log   /var/log/nginx/error.log warn;
        '';

        # FIXME: this normally makes the /nginx_status endpoint availabe, but nextcloud hijacks it and returns a SSL error
        # we need it for prometheus, so it would be *great* to figure out a solution
        statusPage = true;

        virtualHosts = {
          "${config.networking.domain}" = {
            default = true;
            serverAliases = ["www.${config.networking.domain}"];
          };
        };
      };

      logrotate.settings.nginx = {
        enable = true;
        minsize = "50M";
        rotate = "4"; # 4 files of 50mb each
        compress = "";
      };
    };
  };
}
