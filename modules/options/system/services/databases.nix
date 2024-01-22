{lib, ...}: let
  inherit (lib) mkModule;
in {
  options.modules.system.services = {
    # database backends
    database = {
      mysql = mkModule {
        name = "MySQL";
        type = "database";
        port = 3306;
      };

      mongodb = mkModule {
        name = "MongoDB";
        type = "database";
        port = 27017;
      };

      redis = mkModule {
        name = "Redis";
        type = "database";
        port = 6379;
      };

      postgresql = mkModule {
        name = "PostgreSQL";
        type = "database";
        port = 5432;
      };

      garage = mkModule {
        name = "Garage";
        type = "S3 storage";
        port = 5432;
      };
    };
  };
}
