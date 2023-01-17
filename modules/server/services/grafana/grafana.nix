{config, ...}: {
  # TODO: grafana service
  # https://nixos.wiki/wiki/Grafana
  services.grafana = {
    enable = true;
    # Listening address and TCP port
    addr = "127.0.0.1";
    port = 3000;
    # Grafana needs to know on which domain and URL it's running:
    domain = "dash.neushore.dev";
    rootUrl = "https://dash.neushore.dev/grafana/"; # Not needed if it is `https://your.domain/`
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    addSSL = true;
    enableACME = true;
    locations."/grafana/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}/";
      proxyWebsockets = true;
    };
  };
}
