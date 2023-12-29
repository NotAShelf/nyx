{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "me@notashelf.dev";
      };
    };

    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      # FIXME: this normally makes the /nginx_status endpoint availabe, but nextcloud hijacks it and returns a SSL error
      # we need it for prometheus, so it would be *great* to figure out a solution
      statusPage = false;

      # lets be more picky on our ciphers and protocols
      sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2";

      commonHttpConfig = ''
        #real_ip_header CF-Connecting-IP;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
      '';

      virtualHosts = {
        "${config.networking.domain}" = {
          default = true;
          serverAliases = ["www.${config.networking.domain}"];
          extraConfig = ''
            access_log /var/log/nginx/access.log;
            error_log /var/log/nginx/error.log;
          '';
        };
      };
    };
  };
}
