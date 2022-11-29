{}: {
  services = {
    # Prometheus exporter for Grafana
    prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
      openFirewall = true;
      firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
    };
    # TODO: grafana service
  };
}
