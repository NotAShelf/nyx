{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.networking) domain;

  sys = config.modules.system;
  cfg = sys.services.headscale;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = [config.services.headscale.package];

    services = {
      headscale = {
        enable = true;
        address = "0.0.0.0";
        port = 8085;

        settings = {
          server_url = "https://hs.${domain}";

          dns_config = {
            override_local_dns = true;
            base_domain = "${domain}";
            magic_dns = true;
            domains = ["hs.${domain}"];
            nameservers = [
              "9.9.9.9" # no cloudflare, nice
            ];
          };

          log = {
            level = "warn";
          };

          ip_prefixes = [
            "100.64.0.0/10"
            "fd7a:115c:a1e0::/48"
          ];

          db_type = "postgres";
          db_host = "/run/postgresql";
          db_name = "headscale";
          db_user = "headscale";

          # TODO. logtail
          logtail = {
            enabled = false;
          };
        };
      };

      nginx.virtualHosts."hs.${domain}" =
        {
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };

          /*
          # this is a decent looking web-ui, and the below configuration is enough to make it work
          # however tthe security policy of the frontend is quite inconveniencing on a multi-device
          # system - and as such, it remains disabled for the time being
          # also see: https://github.com/gurucomputing/headscale-ui/blob/master/SECURITY.md
          locations."/web" = {
            root = "${inputs'.nyxpkgs.packages.headscale-ui}/share";
          };
          */
        }
        // lib.sslTemplate;
    };
  };
}
