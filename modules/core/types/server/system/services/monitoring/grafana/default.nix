{
  config,
  lib,
  ...
}:
with lib; let
  dev = config.modules.device;
  cfg = config.modules.system.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.monitoring.grafana.enable) {
    networking.firewall.allowedTCPPorts = [config.services.grafana.settings.server.http_port];

    services = {
      grafana = {
        enable = true;
        settings = {
          analytics = {
            reporting_enabled = false;
            check_for_updates = false;
          };

          server = {
            http_addr = "0.0.0.0";
            http_port = 3000;

            root_url = "https://dash.notashelf.dev";
            domain = "dash.notashelf.dev";
            enforce_domain = true;
          };

          "auth.anonymous".enabled = false;
          "auth.basic".enabled = false;

          users = {
            allow_signup = false;
          };

          database = {
            type = "postgres";
            host = "/run/postgresql";
            name = "grafana";
            user = "grafana";
            ssl_mode = "disable";
          };
        };

        provision = {
          datasources.settings = {
            datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                url = "http://localhost:9090";
                orgId = 1;
              }
            ];
          };
        };
      };

      nginx.virtualHosts."dash.notashelf.dev" =
        {
          locations."/" = {
            proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
            proxyWebsockets = true;
          };
        }
        // {
          addSSL = true;
          enableACME = true;
        };
    };
  };
}
