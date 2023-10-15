{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption ifOneEnabled;
  cfg = config.modules.services;

  # mkEnableOption is the same as mkEnableOption but with the default value being equal to cfg.monitoring.enable
  mkEnableOption' = desc: mkEnableOption "${desc}" // {default = cfg.monitoring.enable;};
in {
  options.modules = {
    services = {
      nextcloud.enable = mkEnableOption "Nextcloud service";
      mailserver.enable = mkEnableOption "nixos-mailserver service";
      mkm.enable = mkEnableOption "mkm-ticketing service";
      vaultwarden.enable = mkEnableOption "VaultWarden service";
      forgejo.enable = mkEnableOption "Forgejo service";
      irc.enable = mkEnableOption "Quassel IRC service";
      jellyfin.enable = mkEnableOption "Jellyfin media service";
      matrix.enable = mkEnableOption "Matrix-synapse service";
      wireguard.enable = mkEnableOption "Wireguard service";
      searxng.enable = mkEnableOption "Searxng service";
      miniflux.enable = mkEnableOption "Miniflux service";
      mastodon.enable = mkEnableOption "Mastodon service";

      # monitoring tools
      monitoring = {
        enable = mkEnableOption "system monitoring services" // {default = ifOneEnabled cfg "grafana" "prometheus" "loki";};
        prometheus.enable = mkEnableOption' "Prometheus monitoring service";
        grafana.enable = mkEnableOption' "Grafana monitoring service";
        loki.enable = mkEnableOption' "Loki monitoring service";
      };

      # database backends
      database = {
        mysql.enable = mkEnableOption "MySQL database service";
        mongodb.enable = mkEnableOption "MongoDB service";
        redis.enable = mkEnableOption "Redis service";
        postgresql.enable = mkEnableOption "Postgresql service";
      };
    };
  };
}
