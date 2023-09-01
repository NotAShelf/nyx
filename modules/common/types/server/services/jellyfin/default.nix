{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.services.jellyfin.enable {
    services = {
      jellyfin = {
        enable = true;
        group = "jellyfin";
        user = "jellyfin";
        openFirewall = true;
      };
    };
  };
}
