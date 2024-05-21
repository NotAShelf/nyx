{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;

  sys = config.modules.system;
  cfg = sys.services;

  # mkEnableOption is the same as mkEnableOption but with the default value being equal to cfg.monitoring.enable
  mkEnableOption' = desc: mkEnableOption "${desc}" // {default = cfg.monitoring.enable;};
in {
  # Monitoring tools.
  options.modules.system.services = {
    # TODO: How do I mkService those? They feature multiple host-specific parts
    # that need to be addressed, so seems difficult to move over easily. Perhaps move
    # over the mkEnableOption' usage to the module option root?
    monitoring = {
      enable = mkEnableOption "system monitoring stack";
      prometheus.enable = mkEnableOption' "Prometheus monitoring service";
      grafana.enable = mkEnableOption' "Grafana monitoring service";
      loki.enable = mkEnableOption' "Loki monitoring service";
      uptime-kuma.enable = mkEnableOption' "Uptime Kuma monitoring service";
    };
  };
}
