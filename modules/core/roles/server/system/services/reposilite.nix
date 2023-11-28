{
  config,
  lib,
  inputs',
  ...
}: let
  inherit (lib) mkIf sslTemplate;

  sys = config.modules.system;
in {
  config = mkIf sys.services.reposilite.enable {
    services.reposilite = {
      enable = true;
      package = inputs'.nyxpkgs.packages.reposilite-bin;
      dataDir = "/srv/storage/reposilite";

      openFirewall = true;

      user = "reposilite";
      group = "reposilite";

      settings = {
        port = 8084;
      };
    };

    services.nginx.virtualHosts = {
      "repo.notashelf.dev" =
        {
          locations."/".proxyPass = "http://127.0.0.1:${toString config.services.reposilite.settings.port}";
          extraConfig = ''
            access_log /var/log/nginx/reverse-access.log;
            error_log /var/log/nginx/reverse-error.log;
          '';
        }
        // sslTemplate;
    };
  };
}
