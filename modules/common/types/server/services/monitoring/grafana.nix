{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.modules.services.grafana.enable {
    networking.firewall.allowedTCPPorts = [config.services.grafana.settings.server.http_port];

    services.grafana = {
      enable = true;
      dataDir = "/srv/storage/grafana";

      settings = {
        analytics = {
          # don't report anything
          reporting_enabled = false;

          # don't check for updates, we can't update imperatively
          check_for_updates = false;
        };

        server = {
          # Listening address and TCP port
          http_port = 3000;

          # Grafana needs to know on which domain and URL it's running on:
          http_addr = "127.0.0.1";
          domain = "dash.notashelf.dev";

          # true means HTTP compression is enabled
          enable_gzip = true;

          # use postgresql instead of sqlite
          database = {
            type = "postgres";
            user = "grafana";
            host = "/var/run/postgresql/";
          };
        };
      };
    };
  };
}
