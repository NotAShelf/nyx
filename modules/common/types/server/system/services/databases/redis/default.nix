{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.services;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.database.redis.enable) {
    services.redis = {
      vmOverCommit = true;
      servers = mkIf cfg.nextcloud.enable {
        nextcloud = {
          enable = true;
          user = "nextcloud";
          port = 0;
        };

        searxng = mkIf cfg.searxng.enable {
          enable = true;
          user = "searx";
          port = 6370;
          unixSocketPerm = 660;
        };
      };
    };
  };
}
