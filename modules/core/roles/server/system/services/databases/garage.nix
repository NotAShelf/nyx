{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.database.garage.enable {
    networking.firewall.allowedTCPPorts = [3900 3901 3903];

    environment.systemPackages = [
      pkgs.garage
    ];

    systemd = let
      sc = config.systemd.services.garage.serviceConfig;
      gc = config.services.garage.settings;
    in {
      tmpfiles.rules = [
        "d /srv/storage/garage 0755 ${sc.User} ${sc.Group}"
        "d '${gc.data_dir}' 0700 ${sc.User} ${sc.Group} - -"
        "d '${gc.metadata_dir}' 0700 ${sc.User} ${sc.Group} - -"
      ];

      services.garage = {
        # this lets custom data directory work by having a real user own the service process
        # the user and its group need to be created in the users section
        serviceConfig = {
          User = "garage";
          Group = "garage";
          ReadWritePaths = [gc.data_dir gc.metadata_dir];
          RequiresMountsFor = [gc.data_dir];
          DynamicUser = false;
          PrivateTmp = true;
          ProtectSystem = true;
        };

        environment = {
          RUST_LOG = "debug";
        };
      };
    };

    users = {
      groups.garage = {};

      users.garage = {
        isSystemUser = true;
        createHome = false;
        group = "garage";
      };
    };

    services = {
      garage = {
        enable = true;
        package = pkgs.garage;

        environmentFile = config.age.secrets.garage-env.path;

        settings = {
          metadata_dir = "/srv/storage/garage/meta";
          data_dir = "/srv/storage/garage/data";
          metadata_fsync = false; # synchronous mode for the database engine

          db_engine = "lmdb";
          replication_mode = "none";
          compression_level = -1;

          # For inter-node comms
          rpc_bind_addr = "[::]:3901";
          rpc_secret_file = config.age.secrets.garage-env.path;
          # rpc_public_addr = "127.0.0.1:3901";

          # Standard S3 api endpoint
          s3_api = {
            s3_region = "helios";
            api_bind_addr = "[::]:3900";
          };

          # Static file serve endpoint
          /*
          s3_web = {
            bind_addr = "[::1]:3902";
            root_domain = "s3.notashelf.dev";
            index = "index.html";
          };

          "k2v_api" = {
           "api_bind_addr" = "[::1]:3904";
          };
          */

          # Admin api endpoint
          admin = {
            api_bind_addr = "[::]:3903";
          };
        };
      };

      nginx.virtualHosts."s3.notashelf.dev" =
        {
          locations."/".proxyPass = "http://127.0.0.1:3900";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            # Disable buffering to a temporary file.
            proxy_max_temp_file_size 0;
          '';
        }
        // lib.sslTemplate;
    };
  };
}
