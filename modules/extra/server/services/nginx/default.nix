{
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    networking.domain = "notashelf.dev";

    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "me@notashelf.dev";
      };
    };

    services.nginx = {
      enable = true;
      commonHttpConfig = ''
        real_ip_header CF-Connecting-IP;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
      '';

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = let
        template = {
          forceSSL = true;
          enableACME = true;
        };
      in {
        # website + other stuff
        "notashelf.dev" =
          template
          // {
            serverAliases = ["notashelf.dev"];
            root = "/home/notashelf/Dev/web";
          };
        # jellyfin
        "fin.notashelf.dev" =
          template
          // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:8096/";
              proxyWebsockets = true;
              extraConfig = "proxy_pass_header Authorization;";
            };
          };
        # vaultwawrden
        "vault.notashelf.dev" =
          template
          // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
              extraConfig = "proxy_pass_header Authorization;";
            };
          };
        # gitea
        "git.notashelf.dev" =
          template
          // {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
          };
        # nextcloud
        ${config.services.nextcloud.hostName} = template;

        # mailserver
        "mail.notashelf.dev" = template;

        # webmail
        "webmail.notashelf.dev" = template;

        # matrix-synapse
        "matrix.notashelf.dev" =
          template
          // {
            locations."/".proxyPass = "http://127.0.0.1:8008";
          };

        # grafana dashboard
        ${config.services.grafana.settings.server.domain} =
          {
            addSSL = true;
            enableACME = true;
          }
          // {
            locations."/" = {
              proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
              proxyWebsockets = true;
            };
          };
      };
    };
  };
}
