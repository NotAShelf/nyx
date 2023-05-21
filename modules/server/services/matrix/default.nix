{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];

  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${fqdn}";
    "m.identity_server" = {};
  };
  serverConfig."m.server" = "${config.services.matrix-synapse.settings.server_name}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services.postgresql = {
      enable = true;
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      '';
    };
    services.nginx.virtualHosts = {
      "${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;

        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:8008";

        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
      };
    };

    networking.firewall.allowedTCPPorts = [8008];

    services.matrix-synapse = {
      enable = true;
      settings = {
        database_type = "psycopg2";
        database_args = {
          database = "matrix-synapse";
        };
        server_name = "notashelf.dev";
        public_baseurl = "https://notashelf.dev";
        max_upload_size = "100M";
        listeners = [
          {
            bind_addresses = ["::1"];
            port = 8008;
            resources = [
              {
                names = ["client" "federation"];
                compress = true;
              }
            ];
            tls = false;
            type = "http";
            x_forwarded = true;
          }
        ];
      };
      extraConfigFiles = [config.age.secrets.matrix-secret.path];
    };
  };
}
