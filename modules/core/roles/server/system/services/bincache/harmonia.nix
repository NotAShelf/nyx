{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services.bincache.atticd;
in {
  config = mkIf cfg.enable {
    services = {
      harmonia = {
        enable = true;
        # FIXME: generate a public/private key pair like this:
        # $ nix-store --generate-binary-cache-key cache.yourdomain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
        signKeyPath = "/var/lib/secrets/harmonia.secret";
      };
    };

    nix.settings.allowed-users = ["harmonia"];

    services.nginx = {
      virtualHosts."cache.notashelf.dev" =
        {
          enableACME = true;
          forceSSL = true;
          locations."/".extraConfig = ''
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_redirect http:// https://;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;

            #zstd on;
            #zstd_types application/x-nix-archive;
          '';
        }
        // lib.sslTemplate;
    };
  };
}
