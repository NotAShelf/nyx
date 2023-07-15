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
    services.redis = {
      vmOverCommit = true;
      servers = {
        nextcloud = {
          enable = true;
          user = "nextcloud";
          port = 0;
        };

        searxng = {
          enable = true;
          user = "searx";
          port = 6370;
          unixSocketPerm = 660;
        };
      };
    };
  };
}
