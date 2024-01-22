{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    location.provider = "geoclue2";

    services.geoclue2 = {
      # enable geoclue2 only if location.provider is geoclue2
      enable = config.location.provider == "geoclue2";

      # TODO: make gammastep fall back to local if geoclue2 is disabled
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
