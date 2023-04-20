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
      # Listening address and TCP port
      addr = "127.0.0.1";
      port = 3000;
      # Grafana needs to know on which domain and URL it's running on:
      settings.server.domain = "dash.notashelf.dev";
      rootUrl = "https://dash.notashelf.dev/grafana/"; # Not needed if it is `https://your.domain/`
    };

    services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
      addSSL = true;
      enableACME = true;
      locations."/grafana/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}/";
        proxyWebsockets = true;
      };
    };
  };
}
