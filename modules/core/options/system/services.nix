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
    type ? "",
    host ? "127.0.0.1", # default to listening only on localhost
    port ? 0,
    extraOptions ? {},
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
      // extraOptions;
  };
in {
  options.modules.system = {
    services = {
      mailserver.enable = mkEnableOption "nixos-mailserver service";
      mkm.enable = mkEnableOption "mkm-ticketing service";

      nextcloud = mkModule {
        name = "Nextcloud";
        type = "cloud storage";
      };

      nginx = mkModule {
        name = "Nginx";
        type = "webserver";
      };

      vaultwarden = mkModule {
        name = "VaultWarden";
        type = "password manager";
        port = 8222;
      };

      forgejo = mkModule {
        name = "Forgejo";
        type = "forge";
        port = 7000;
      };

      quassel = mkModule {
        name = "Quassel";
        type = "IRC";
        port = 4242;
      };

      jellyfin = mkModule {
        name = "Jellyfin";
        type = "media";
        port = 8096;
      };

      searxng = mkModule {
        name = "Searxng";
        type = "meta search engine";
        port = 8888;
      };

      miniflux = mkModule {
        name = "Miniflux";
        type = "RSS reader";
      };

      reposilite = mkModule {
        name = "Reposilite";
        port = 8084;
      };

      elasticsearch = mkModule {
        name = "Elasticsearch";
        port = 9200;
      };

      kanidm = mkModule {
        name = "Kanidm";
        port = 8443;
      };

      # monitoring tools
      # TODO: how do I mkModule those? they feature multiple host-specific parts
      # that need to be adressed
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
        headscale = mkModule {
          name = "Headscale";
          type = "networking";
          port = 8085;
          extraOptions = {
            domain = mkOption {
              type = types.str;
              example = "headscale.example.com";
              description = "The domain name to use for headscale";
            };
          };
        };
      };

      # binary cache backends
      bincache = {
        harmonia = mkModule {
          name = "Harmonia";
          type = "binary cache";
          port = 5000;
        };

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
