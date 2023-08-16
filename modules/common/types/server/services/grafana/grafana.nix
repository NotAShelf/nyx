{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.services.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.grafana)) {
    networking.firewall.allowedTCPPorts = [config.services.grafana.settings.server.http_port];

    services.grafana = {
      enable = true;
      dataDir = "/srv/storage/grafana";

      settings = {
        server = {
          # Listening address and TCP port
          http_port = 3000;
          # Grafana needs to know on which domain and URL it's running on:
          http_addr = "127.0.0.1";
          domain = "dash.notashelf.dev";

          # true means HTTP compression is enabled
          enable_gzip = true;
        };
      };
    };
  };
}
