{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  domain = "cache" + config.networking.domain;
  address = "127.0.0.1";
  port = 8100;

  sys = config.modules.system;
  cfg = sys.services.atticd;
in {
  imports = [inputs.atticd.nixosModules.atticd];
  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.attic-client];

    networking.firewall.allowedTCPPorts = [port];

    users = {
      groups.atticd = {};

      users."atticd" = {
        isSystemUser = true;
        group = "atticd";
      };
    };

    services = {
      atticd = {
        enable = true;
        credentialsFile = config.age.secrets.attic-env.path;
        user = "atticd";
        group = "atticd";

        settings = {
          listen = "${address + ":" + (toString port)}"; # this listens ONLY locally
          database.url = "postgresql:///atticd?host=/run/postgresql";

          allowed-hosts = ["${domain}"];
          api-endpoint = "https://${domain}/";

          storage = {
            type = "s3";
            region = "helios";
            bucket = "attic-cache";
            endpoint = "https://s3.notashelf.dev";
          };

          chunking = let
            KB = x: x * 1024;
          in {
            nar-size-threshold = KB 64;
            min-size = KB 16;
            avg-size = KB 64;
            max-size = KB 256;
          };

          garbage-collection = {
            interval = "24 hours";
            default-retention-period = "6 weeks";
          };
        };
      };

      nginx.virtualHosts."${domain}" = {
        extraConfig = ''
          client_max_body_size 0;

          proxy_read_timeout 300s;
          proxy_send_timeout 300s;
        '';

        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };
}
