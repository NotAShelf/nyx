{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) meta;
in {
  config = mkIf meta.isWayland {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
