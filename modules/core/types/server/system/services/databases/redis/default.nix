{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.system.services;
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
          databases = 16;
          logLevel = "debug";
          requirePass = "searxng";
        };

        forgejo = mkIf cfg.forgejo.enable {
          enable = true;
          user = "forgejo";
          port = 6371;
          databases = 16;
          logLevel = "debug";
          requirePass = "forgejo";
        };

        mastodon = mkIf cfg.matodon.enable {
          enable = true;
          user = "mastodon";
          port = 6372;
          databases = 16;
          logLevel = "debug";
        };
      };
    };
  };
}
