{
  pkgs,
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
        "notashelf.dev" =
          template
          // {
            serverAliases = ["notashelf.dev"];
            root = "/home/notashelf/Dev/web";
          };
        "fin.notashelf.dev" =
          template
          // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:8096/";
              proxyWebsockets = true;
              extraConfig = "proxy_pass_header Authorization;";
            };
          };
        "vault.notashelf.dev" =
          template
          // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
              extraConfig = "proxy_pass_header Authorization;";
            };
          };
        "git.notashelf.dev" =
          template
          // {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
          };
        ${config.services.nextcloud.hostName} = template;

        "matrix.notashelf.dev" =
          template
          // {
            locations."/".proxyPass = "http://127.0.0.1:8008";
          };

        ${config.services.grafana.settings.server.domain} =
          template
          // {
            locations."/grafana/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}/";
              proxyWebsockets = true;
            };
          };
      };
    };
  };
}
