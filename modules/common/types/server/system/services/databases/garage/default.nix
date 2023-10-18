{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  cfg = config.modules.system.services;
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.database.garage.enable) {
    networking.firewall.allowedTCPPorts = [3900 3901 3902];

    environment.systemPackages = [
      pkgs.garage
    ];

    services = {
      garage = {
        enable = true;
        package = pkgs.garage;

        settings = {
          metadata_dir = "/srv/storage/garage/meta";
          data_dir = "/srv/storage/garage/data";
          metadata_fsync = false; # synchronous mode for the database engin

          db_engine = "lmdb";
          eplication_mode = 2;
          compression_level = -1;

          # For inter-node comms
          rpc_bind_addr = "[::]:3901";
          rpc_public_addr = "127.0.0.1:3901";

          # Standard S3 api endpoint
          s3_api = {
            s3_region = "helios";
            api_bind_addr = "[::]:3900";
          };

          # Static file serve endpoint
          s3_web = {
            bind_addr = "0.0.0.0:3901";
            root_domain = "s3.notashelf.dev";
            index = "index.html";
          };

          # Admin api endpoint
          admin = {
            api_bind_addr = "[::]:3903";
          };
        };
      };
    };
  };
}
