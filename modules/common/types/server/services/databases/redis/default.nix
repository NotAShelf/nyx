{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.services.database.redis.enable {
    services.redis = {
      vmOverCommit = true;
      servers = {
        nextcloud = {
          enable = true;
          user = "nextcloud";
        };

        searxng = {
          enable = true;
          user = "searx";
          port = 6370;
          unixSocketPerm = 660; # required to use the socket by non-redis users
        };
      };
    };
  };
}
