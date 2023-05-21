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

  clientConfig = {
    "m.homeserver".base_url = "https://${config.networking.hostName}${config.networking.domain}";
    "m.identity_server" = {};
  };
  serverConfig."m.server" = "${config.services.matrix-synapse.settings.server_name}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    add_header 'Referrer-Policy' 'origin-when-cross-origin';
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
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
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
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
