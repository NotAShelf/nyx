{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.system.services;
  acceptedTypes = ["server" "hybrid"];
in
  mkIf ((builtins.elem dev.type acceptedTypes) && cfg.jellyfin.enable) {
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
            proxyPass = "http://127.0.0.1:8096/";
            proxyWebsockets = true;
            extraConfig = "proxy_pass_header Authorization;";
          };
        }
        // lib.sslTemplate;
    };
  }
