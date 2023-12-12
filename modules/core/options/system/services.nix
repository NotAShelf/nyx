{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  sys = config.modules.system;
  cfg = sys.services;

  # mkEnableOption is the same as mkEnableOption but with the default value being equal to cfg.monitoring.enable
  mkEnableOption' = desc: mkEnableOption "${desc}" // {default = cfg.monitoring.enable;};

  # mkModule takes a few arguments to generate a module for a service without
  # repeating the same options over and over
  mkModule = {
    name,
    type,
    host ? "127.0.0.1",
    port ? 0,
    extraSettings ? {},
  }: {
    enable = mkEnableOption "${name} ${type} service";
    settings =
      {
        host = mkOption {
          type = types.str;
          default = host;
          description = "The host ${name} will listen on";
        };

        port = mkOption {
          type = types.int;
          default = port;
          description = "The port ${name} will listen on";
        };
      }
      // extraSettings;
  };
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
      searxng.enable = mkEnableOption "Searxng service";
      miniflux.enable = mkEnableOption "Miniflux service";
      reposilite.enable = mkEnableOption "Repeosilite service";
      elasticsearch.enable = mkEnableOption "Elasticsearch service";
      kanidm.enable = mkEnableOption "Kanidm service";

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
        harmonia.enable = mkEnableOption "Harmonia binary cache service";
        atticd = mkModule {
          name = "Atticd";
          type = "binary cache";
          port = 8100;
        };
      };

      # self-hosted/decentralized social networks
      social = {
        mastodon = mkModule {
          name = "Mastodon";
          type = "social";
        };
        matrix = mkModule {
          name = "Matrix";
          type = "social";
          port = 8008;
        };
      };

      # database backends
      database = {
        mysql = mkModule {
          name = "MySQL";
          type = "database";
          port = 3306;
        };

        mongodb = mkModule {
          name = "MongoDB";
          type = "database";
          port = 27017;
        };

        redis = mkModule {
          name = "Redis";
          type = "database";
          port = 6379;
        };

        postgresql = mkModule {
          name = "PostgreSQL";
          type = "database";
          port = 5432;
        };

        garage = mkModule {
          name = "Garage";
          type = "S3 storage";
          port = 5432;
        };
      };
    };
  };
}
