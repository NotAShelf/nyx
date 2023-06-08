{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.services.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.database.redis)) {
    services.redis.servers = {
      nextcloud = {
        enable = true;
        port = 0;
      };
    };
  };
}
