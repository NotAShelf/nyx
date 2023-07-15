{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.services.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.database.mysql)) {
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
