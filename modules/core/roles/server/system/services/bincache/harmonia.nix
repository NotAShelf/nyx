{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services.bincache.harmonia;

  inherit (cfg.settings) port host;
in {
  config = mkIf cfg.enable {
    users = {
      groups.harmonia = {};
      users.harmonia = {
        isSystemUser = true;
        createHome = true;
        group = "harmonia";
        home = "/srv/storage/harmonia";
      };
    };

    services = {
      harmonia = {
        enable = true;
        # NOTE: generated via
        # $ nix-store --generate-binary-cache-key cache.domain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
        signKeyPath = config.age.secrets.harmonia-privateKey.path;
        settings = {
          # default ip:hostname to bind to
          bind = "${host}:${toString port}";
          priority = 50; # prefer cache.nixos.org
        };
      };
    };

    nix.settings.allowed-users = ["harmonia"];

    services.nginx = {
      virtualHosts."cache.notashelf.dev" =
        {
          locations."/".extraConfig = ''
            proxy_pass http://127.0.0.1:${toString port};
            proxy_set_header Host $host;
            proxy_redirect http:// https://;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            zstd on;
            zstd_types application/x-nix-archive;
          '';

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
