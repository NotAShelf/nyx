{config, ...}: {
  services = {
    # Prometheus exporter for Grafana
    prometheus = {
      enable = true;
      port = 9100;
      # enabled exporters
      exporters = {
        node = {
          enable = true;
          port = 9101;
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
      };
      scrapeConfigs = [
        {
          job_name = "test_job";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
      ];
    };
  };
}
