{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.jellyfin.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    services = {
      jellyfin = {
        enable = true;
        group = "jellyfin";
        user = "jellyfin";
        openFirewall = true;
      };

      nginx.virtualHosts. "fin.notashelf.dev" =
        {
          locations."/" = {
            # TODO: the port is not customizable in the upstream service, PR nixpkgs
            proxyPass = "http://127.0.0.1:${cfg.jellyfin.settings.port}/";
            proxyWebsockets = true;
            extraConfig = "proxy_pass_header Authorization;";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
