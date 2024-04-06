{
  inputs',
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.networking.headscale.enable {
    environment.systemPackages = [config.services.headscale.package];
    networking.firewall.allowedUDPPorts = [8086]; # DERP

    services = {
      headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8085;

        settings = {
          grpc_listen_addr = "127.0.0.1:50443";
          grpc_allow_insecure = false;

          server_url = "https://hs.notashelf.dev";
          tls_cert_path = null;
          tls_key_path = null;

          # default headscale prefix
          ip_prefixes = [
            "100.64.0.0/10"
            "fd7a:115c:a1e0::/48"
          ];

          dns_config = {
            override_local_dns = true;
            magic_dns = true;
            base_domain = "notashelf.dev";
            domains = [];
            nameservers = [
              "9.9.9.9" # no cloudflare, nice
            ];

            /*
            extra_records = [
              {
                name = "idm.notashelf.dev";
                type = "A";
                value = "100.64.0.1"; # NOTE: this should be the address of the "host" node - which is the server
              }
            ];
            */
          };

          acl_policy_path = pkgs.writeText "headscale-acl" (builtins.toJSON {
            acls = [
              {
                # Allow client --> server traffic
                # but not the other way around.
                # Servers face the internet, clients
                # do so far less.
                action = "accept";
                proto = "tcp";
                src = ["tag:client"];
                dst = ["tag:server:*"];
              }
            ];

            # Allow all users to SSH into their own devices in check mode.
            ssh = [
              {
                action = "check";
                src = ["autogroup:member"];
                dst = ["autogroup:self"];
                users = ["autogroup:nonroot" "root"];
              }
            ];
          });

          derp = {
            server = {
              enabled = true;
              region_id = 900;
              region_code = "headscale";
              region_name = "Headscale Embedded DERP";
              stun_listen_addr = "0.0.0.0:8344";
            };

            urls = [];
            paths = [];

            auto_update_enabled = false;
            update_frequency = "24h";
          };

          disable_check_updates = true;
          ephemeral_node_inactivity_timeout = "30m";
          node_update_check_interval = "10s";

          /*
          db_type = "postgres";
          db_host = "/run/postgresql";
          db_name = "headscale";
          db_user = "headscale";
          db_port = 5432; # not ignored for some reason
          */

          metrics_listen_addr = "127.0.0.1:8087";

          log = {
            format = "text";
            level = "info";
          };

          # TODO: logtail
          logtail = {
            enabled = false;
          };

          randomize_client_port = false;
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
