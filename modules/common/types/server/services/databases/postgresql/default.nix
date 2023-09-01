{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.modules.services.database.postgresql.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      checkConfig = true;
      dataDir = "/srv/storage/postgresql/${config.services.postgresql.package.psqlSchema}";
    };
  };
}
