{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  #cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in {
  # TODO: grafana service
  # TODO: grafana service override
  # https://nixos.wiki/wiki/Grafana
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services.grafana = {
      enable = true;

      settings = {
        server = {
          # Listening address and TCP port
          http_port = 3000;
          # Grafana needs to know on which domain and URL it's running on:
          http_addr = "127.0.0.1";
          domain = "dash.notashelf.dev";
          ROOT_URL = "https://dash.notashelf.dev/grafana/"; # Not needed if it is `https://your.domain/`
        };
      };
    };
  };
}
