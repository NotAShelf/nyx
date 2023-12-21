{
  inputs',
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services.headscale;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = [config.services.headscale.package];
    networking = {
      firewall.allowedUDPPorts = [8086]; # DERP
    };

    services = {
      headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8085;

        settings = {
          server_url = "https://hs.notashelf.dev";
          tls_cert_path = null;
          tls_key_path = null;

          dns_config = {
            override_local_dns = true;
            magic_dns = true;
            base_domain = "notashelf.dev";
            domains = ["ts.notashelf.dev"];
            nameservers = [
              "9.9.9.9" # no cloudflare, nice
            ];

            extra_records = [
              {
                name = "idm.notashelf.dev";
                type = "A";
                value = "100.64.0.1"; # NOTE: this should be the address of the "host" node - which is the server
              }
              {
                name = "helios";
                type = "A";
                value = "100.64.0.1";
              }
            ];
          };

          derp.server = {
            enabled = true;
            region_id = 999;
            stun_listen_addr = "0.0.0.0:8086";

            auto_update_enable = true;
            update_frequency = "24h";
          };

          log = {
            format = "text";
            level = "info";
          };

          ip_prefixes = [
            "100.64.0.0/10"
            "fd7a:115c:a1e0::/48"
          ];

          /*
          db_type = "postgres";
          db_host = "/run/postgresql";
          db_name = "headscale";
          db_user = "headscale";
          db_port = 5432; # not ignored for some reason
          */

          metrics_listen_addr = "127.0.0.1:8087";
          # TODO: logtail
          logtail = {
            enabled = false;
          };
        };
      };

      nginx.virtualHosts."hs.notashelf.dev" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };

          # see <https://github.com/gurucomputing/headscale-ui/blob/master/SECURITY.md> before
          # possibly using the web frontend
          "/web" = {
            root = "${inputs'.nyxpkgs.packages.headscale-ui}/share";
          };
        };
      };
    };

    systemd.services = {
      # TODO: consider enabling postgresql storage
      # postgresql is normally pretty neat, but unless you expect your setup to receive
      # very frequent logins, sqlite (default) storage may be more performant
      # headscale.requires = ["postgresql.service"];

      create-headscale-user = {
        description = "Create a headscale user and preauth keys for this server";

        wantedBy = ["multi-user.target"];
        after = ["headscale.service"];

        serviceConfig = {
          Type = "oneshot";
          User = "headscale";
        };

        path = [pkgs.headscale];
        script = ''
          if ! headscale users list | grep notashelf; then
            headscale users create notashelf
            headscale --user notashelf preauthkeys create --reusable --expiration 100y > /var/lib/headscale/preauth.key
          fi
        '';
      };
    };
  };
}
