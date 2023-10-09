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
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.database.postgresql)) {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      checkConfig = true;
      dataDir = "/srv/storage/postgresql/${config.services.postgresql.package.psqlSchema}";
    };
  };
}
