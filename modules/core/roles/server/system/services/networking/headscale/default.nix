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
  imports = [
    ./acls.nix
    ./derp.nix
    ./dns.nix
  ];

  config = mkIf cfg.networking.headscale.enable {
    environment.systemPackages = [config.services.headscale.package];
    networking.firewall.allowedUDPPorts = [3478 8086]; # DERP

    services = {
      headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8085;

        settings = {
          noise.private_key_path = config.age.secrets.headscale-noise.path;

          # grpc
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

          # database
          db_type = "sqlite3"; # postgres
          db_path = "/var/lib/headscale/db.sqlite";
          db_name = "headscale";
          db_user = config.services.headscale.user;

          # misc
          metrics_listen_addr = "127.0.0.1:8086";
          randomize_client_port = false;
          disable_check_updates = true;
          ephemeral_node_inactivity_timeout = "30m";
          node_update_check_interval = "10s";

          # logging
          log = {
            format = "text";
            level = "info";
          };

          logtail.enabled = false;
        };
      };

      nginx.virtualHosts."hs.notashelf.dev" = {
        forceSSL = true;
        enableACME = true;
        quic = true;
        http3 = true;

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
          "/web" = {
            root = "${inputs'.nyxexprs.packages.headscale-ui}/share";
          };
        };

        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        '';
      };
    };

    systemd.services = {
      tailscaled.after = ["headscale.service"];
      headscale = {
        # reduce headscale stop timer duration
        # so that restarting Headscale is a lot faster
        # serviceConfig.TimeoutStopSec = "30s";
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
