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
  options.modules.system = {
    services = {
      nextcloud.enable = mkEnableOption "Nextcloud service";
      mailserver.enable = mkEnableOption "nixos-mailserver service";
      mkm.enable = mkEnableOption "mkm-ticketing service";
      vaultwarden.enable = mkEnableOption "VaultWarden service";
      forgejo.enable = mkEnableOption "Forgejo service";
      irc.enable = mkEnableOption "Quassel IRC service";
      jellyfin.enable = mkEnableOption "Jellyfin media service";
      matrix.enable = mkEnableOption "Matrix-synapse service";
      searxng.enable = mkEnableOption "Searxng service";
      miniflux.enable = mkEnableOption "Miniflux service";
      mastodon.enable = mkEnableOption "Mastodon service";
      reposilite.enable = mkEnableOption "Repeosilite service";
      elasticsearch.enable = mkEnableOption "Elasticsearch service";

      # monitoring tools
      monitoring = {
        enable = mkEnableOption "system monitoring stack";
        prometheus.enable = mkEnableOption' "Prometheus monitoring service";
        grafana.enable = mkEnableOption' "Grafana monitoring service";
        loki.enable = mkEnableOption' "Loki monitoring service";
        uptime-kuma.enable = mkEnableOption' "Uptime Kuma monitoring service";
      };

      # networking
      networking = {
        wireguard.enable = mkEnableOption "Wireguard service";
        headscale.enable = mkEnableOption "Headscale service";
      };

      # binary cache backends
      bincache = {
        atticd.enable = mkEnableOption "Atticd binary cache service";
        harmonia.enable = mkEnableOption "Harmonia binary cache service";
      };

      # database backends
      database = {
        mysql.enable = mkEnableOption "MySQL database service";
        mongodb.enable = mkEnableOption "MongoDB service";
        redis.enable = mkEnableOption "Redis service";
        postgresql.enable = mkEnableOption "Postgresql service";
        garage.enable = mkEnableOption "Garage S3 service";
      };
    };
  };
}
