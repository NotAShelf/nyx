{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.modules.services;
  # ifOneEnabled takes a parent option and 3 child options and checks if at least one of them is enabled
  # => ifOneEnabled config.modules.services "service1" "service2" "service3"
  ifOneEnabled = cfg: a: b: c: cfg.a || cfg.b || cfg.c;
in {
  options.modules = {
    services = {
      nextcloud = mkEnableOption "Nextcloud service";
      mailserver = mkEnableOption "nixos-mailserver service";
      mkm = mkEnableOption "mkm-ticketing service";
      vaultwarden = mkEnableOption "VaultWarden service";
      gitea = mkEnableOption "Gitea service";
      irc = mkEnableOption "Quassel IRC service";
      jellyfin = mkEnableOption "Jellyfin media service";
      matrix = mkEnableOption "Matrix-synapse service";
      wireguard = mkEnableOption "Wireguard service";
      searxng = mkEnableOption "Searxng service";

      monitoring = let
        # mkEnableOption is the same as mkEnableOption but with the default value being equal to cfg.monitoring.enable
        mkEnableOption' = desc: mkEnableOption "${desc};" {default = cfg.monitoring.enable;};
      in {
        enable = mkEnableOption "system monitoring services" // {default = ifOneEnabled cfg "grafana" "prometheus" "loki";};

        prometheus = mkEnableOption' "Prometheus monitoring service";
        grafana = mkEnableOption' "Grafana monitoring service";
        loki = mkEnableOption' "Loki monitoring service";
      };

      # database backends
      database = {
        mysql = mkEnableOption "MySQL database service";
        mongodb = mkEnableOption "MongoDB service";
        redis = mkEnableOption "Redis service";
        postgresql = mkEnableOption "Postgresql service";
      };
    };
  };
}
