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

      virtualHosts = {
        # website + other stuff
        "notashelf.dev" =
          {
            serverAliases = ["notashelf.dev"];
            root = "/home/notashelf/Dev/web";
          }
          // lib.sslTemplate;
      };
    };
  };
}
