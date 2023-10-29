{
  config,
  lib,
  self',
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.services.reposilite.enable {
    services.reposilite = {
      enable = true;
      package = self'.packages.reposilite;

      settings = {
        user = "reposilite";
        group = "reposilite";

        port = 8084;
        dataDir = "/srv/storage/reposilite";
      };
    };
  };
}
