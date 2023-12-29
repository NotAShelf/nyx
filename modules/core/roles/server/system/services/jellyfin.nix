{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.system.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.jellyfin.enable) {
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
        }
        // lib.sslTemplate;
    };
  };
}
