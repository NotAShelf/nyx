{lib, ...}: let
  inherit (lib) mkService;
in {
  options.modules.system.services = {
    # database backends
    database = {
      mysql = mkService {
        name = "MySQL";
        type = "database";
        port = 3306;
      };

      mongodb = mkService {
        name = "MongoDB";
        type = "database";
        port = 27017;
      };

      redis = mkService {
        name = "Redis";
        type = "database";
        port = 6379;
      };

      postgresql = mkService {
        name = "PostgreSQL";
        type = "database";
        port = 5432;
      };

      garage = mkService {
        name = "Garage";
        type = "S3 storage";
        port = 5432;
      };
    };
  };
}
