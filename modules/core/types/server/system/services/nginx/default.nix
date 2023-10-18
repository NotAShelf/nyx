{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    networking.domain = "notashelf.dev";

    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "me@notashelf.dev";
      };
    };

    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      commonHttpConfig = ''
        real_ip_header CF-Connecting-IP;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
      '';

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
          {
            locations."/" = {
              proxyPass = "http://127.0.0.1:8096/";
              proxyWebsockets = true;
              extraConfig = "proxy_pass_header Authorization;";
            };
          }
          // template;

        # vaultwawrden
        "vault.notashelf.dev" =
          {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
              extraConfig = "proxy_pass_header Authorization;";
            };
          }
          // template;

        # gitea
        "git.notashelf.dev" =
          {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.forgejo.settings.server.HTTP_PORT}";
          }
          // template;

        # nextcloud
        "cloud.notashelf.dev" = template;

        # mailserver
        "mail.notashelf.dev" = template;

        # webmail
        "webmail.notashelf.dev" = template;

        # mastodon
        "social.notashelf.dev" = template;

        # matrix-synapse
        "matrix.notashelf.dev" =
          {
            locations."/".proxyPass = "http://127.0.0.1:8008";
          }
          // template;

        "search.notashelf.dev" =
          {
            locations."/".proxyPass = "http://127.0.0.1:8888";
            extraConfig = ''
              access_log /dev/null;
              error_log /dev/null;
              proxy_connect_timeout 60s;
              proxy_send_timeout 60s;
              proxy_read_timeout 60s;
            '';
          }
          // template;

        # grafana dashboard
        "dash.notashelf.dev" =
          {
            locations."/" = {
              proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
              proxyWebsockets = true;
            };
          }
          // {
            addSSL = true;
            enableACME = true;
          };
      };
    };
  };
}
