{
  config,
  lib,
  ...
}: let
  domain = "up.notashelf.dev";
in {
  users = {
    users.uptime-kuma = {
      isSystemUser = true;
      group = "uptime-kuma";
    };
    groups.uptime-kuma = {};
  };

  systemd.services.uptime-kuma = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "uptime-kuma";
      Group = "uptime-kuma";
    };
  };

  services = {
    uptime-kuma = {
      enable = true;
      settings = {
        PORT = "4000";
      };
    };

    nginx.virtualHosts."${domain}" =
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}";
          proxyWebsockets = true;
        };
      }
      // lib.sslTemplate;
  };
}
