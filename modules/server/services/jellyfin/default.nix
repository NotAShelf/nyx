{lib, ...}:
with lib; let
  domain = "jellyfin.notashelf.dev";
  device = config.modules.device;
  cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in
  mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      jellyfin = {
        enable = true;
        group = "jellyfin";
        user = "jellyfin";
        openFirewall = true;
      };

      nginx = {
        enable = true;
        virtualHosts.${domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://127.0.0.1:8096";
        };
      };
    };
  }
