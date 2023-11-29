{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = config.services.loki;
in {
  config = mkIf sys.services.monitoring.loki.enable {
    # https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
    services.loki = {
      enable = true;
      dataDir = "/srv/storage/loki";
      extraFlags = ["--config.expand-env=true"];

      configuration = {
        auth_enabled = false;

        server = {
          http_listen_port = 3030;
          log_level = "warn";
        };

        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore = {
                store = "inmemory";
              };
              replication_factor = 1;
            };
          };
          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 999999;
          chunk_retain_period = "30s";
          max_transfer_retries = 0;
        };

        schema_config.configs = [
          {
            from = "2022-05-14";
            store = "boltdb";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "168h";
            };
          }
        ];

        storage_config = {
          boltdb.directory = "${cfg.dataDir}/boltdb-index";
          filesystem.directory = "${cfg.dataDir}/storage-chunks";

          boltdb_shipper = {
            active_index_directory = "/srv/storage/loki/boltdb-shipper-active";
            cache_location = "/srv/storage/loki/boltdb-shipper-cache";
            cache_ttl = "24h";
            shared_store = "filesystem";
          };
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };

        chunk_store_config = {
          max_look_back_period = "0s";
        };

        table_manager = {
          retention_deletes_enabled = false;
          retention_period = "0s";
        };

        compactor = {
          shared_store = "filesystem";
          working_directory = "${cfg.dataDir}/compactor-work";
          compactor_ring = {
            kvstore = {
              store = "inmemory";
            };
          };
        };
      };
      # user, group, dataDir, extraFlags, (configFile)
    };
  };
}
