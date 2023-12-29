{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.monitoring.prometheus.enable {
    services = {
      # Prometheus exporter for Grafana
      prometheus = {
        enable = true;
        port = 9100;

        # relatively frequent scraping intervals
        globalConfig = {
          scrape_interval = "10s";
          scrape_timeout = "2s";
        };

        # enabled exporters
        exporters = {
          node = {
            enable = true;
            port = 9101;
            enabledCollectors = ["systemd" "processes"];
          };

          redis = {
            enable = true;
            port = 9102;
            user = "redis";
          };

          postgres = {
            enable = true;
            port = 9103;
            user = "postgres";
          };

          nginx = {
            enable = false;
            port = 9104;
          };

          smartctl = {
            inherit (config.services.smartd) enable;
            openFirewall = config.services.smartd.enable;
            # Defaults:
            user = "smartctl-exporter";
            group = "disk";
            port = 9110;
          };
        };

        scrapeConfigs = [
          # internal scrape jobs
          {
            job_name = "prometheus";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9100"];}];
          }
          {
            job_name = "node";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9101"];}];
          }
          {
            job_name = "redis";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9102"];}];
          }
          {
            job_name = "postgres";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9103"];}];
          }
          {
            job_name = "nginx";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9104"];}];
          }
          {
            job_name = "endlessh-go";
            scrape_interval = "30s";
            static_configs = [{targets = ["localhost:9105"];}];
          }

          # TODO: exterenal scrape jobs - over tailscale/wireguard mesh
        ];
      };
    };
  };
}
