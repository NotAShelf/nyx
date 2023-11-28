{
  config,
  lib,
  ...
}: let
  domain = "up.notashelf.dev";
in {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "4000";
    };
  };
  services.nginx.virtualHosts."${domain}" =
    {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}";
        proxyWebsockets = true;
      };
    }
    // lib.sslTemplate;
}
