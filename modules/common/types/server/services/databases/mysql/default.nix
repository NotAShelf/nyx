{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.modules.services.database.mysql.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;

      # databases and users
      ensureDatabases = ["mkm"];
      ensureUsers = [
        {
          name = "mkm";
          ensurePermissions = {
            "mkm.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}
