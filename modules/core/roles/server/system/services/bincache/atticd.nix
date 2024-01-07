{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services.bincache.atticd;

  domain = "cache" + config.networking.domain;
  inherit (cfg.settings) host port;
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

    systemd.services.atticd = {
      serviceConfig.DynamicUser = lib.mkForce false;
    };

    services = {
      atticd = {
        enable = true;
        credentialsFile = config.age.secrets.attic-env.path;
        user = "atticd";
        group = "atticd";

        settings = {
          listen = "${host}:${toString port}"; # this listens ONLY locally
          database.url = "postgresql:///atticd?host=/run/postgresql";

          allowed-hosts = ["${domain}"];
          api-endpoint = "https://${domain}/";
          require-proof-of-possession = false;

          /*
          storage = {
            type = "s3";
            region = "helios";
            bucket = "attic-cache";
            endpoint = "https://s3.notashelf.dev";
          };
          */

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
          proxyPass = "http://${host}:${toString port}";
        };
      };
    };
  };
}
