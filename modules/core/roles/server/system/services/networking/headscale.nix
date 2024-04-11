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
    networking.firewall.allowedUDPPorts = [3478 8086]; # DERP

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

          acl_policy_path = pkgs.writeText "headscale-acl" (let
            mkHost = list: map (name: "host:${name}") list;
            mkGroup = list: map (name: "group:${name}") list;
          in
            builtins.toJSON {
              hosts = {
                helios = "100.64.0.1";
                enyo = "100.64.0.2";
                icarus = "100.64.0.3";
                hermes = "100.64.0.4";
              };

              # sort hosts into groups based on their purpose
              # helios is a server, the rest are clients
              groups = {
                "group:server" = mkHost ["helios"];
                "group:client" = mkHost ["enyo" "icarus" "hermes"];
              };

              # apply tags based on groups
              tagOwners = {
                "tag:server" = (mkGroup ["server"]) ++ ["autogroup:admin"];
                "tag:client" = (mkGroup ["client"]) ++ ["autogroup:admin"];
              };

              acls = [
                # All members can access their own devices
                {
                  action = "accept";
                  src = ["autogroup:members"];
                  dst = ["autogroup:self:*"];
                }

                # allow nodes tagged as client to connect to nodes tagged as server
                # on any port
                {
                  action = "accept";
                  src = ["group:client"];
                  dst = [
                    "tag:server:*"
                  ];
                }

                # allow nodes tagged as clients to connect to other nodes tagged as clients
                {
                  action = "accept";
                  src = ["group:client"];
                  dst = [
                    "tag:client:*"
                  ];
                }
              ];

              ssh = [
                # Allow all users to SSH into their own devices in check mode.
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
              stun_listen_addr = "0.0.0.0:3478";

              # Region code and name are displayed in the Tailscale UI to identify a DERP region
              region_code = "headscale";
              region_name = "Headscale Embedded DERP";
              region_id = 999;
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

          "/metrics" = {
            proxyPass = "http://${toString config.services.headscale.settings.metrics_listen_addr}/metrics";
          };

          # see <https://github.com/gurucomputing/headscale-ui/blob/master/SECURITY.md> before
          # possibly using the web frontend
          #"/web" = {
          #  root = "${inputs'.nyxpkgs.packages.headscale-ui}/share";
          #};
        };
      };
    };

    systemd.services = {
      headscale = {
        # reduce headscale stop timer duration
        # so that restarting Headscale is a lot faster
        serviceConfig.TimeoutStopSec = "30s";
        environment = {
          HEADSCALE_EXPERIMENTAL_FEATURE_SSH = "1";

          HEADSCALE_DEBUG_TAILSQL_ENABLED = "1";
          HEADSCALE_DEBUG_TAILSQL_STATE_DIR = "${config.users.users.headscale.home}/tailsql";
        };

        # TODO: consider enabling postgresql storage
        # postgresql is normally pretty neat, but unless you expect your setup to receive
        # very frequent logins, sqlite (default) storage may be more performant
        # headscale.requires = ["postgresql.service"];
      };

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
