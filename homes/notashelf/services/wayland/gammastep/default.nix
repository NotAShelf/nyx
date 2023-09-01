{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice isWayland;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && (isWayland osConfig)) {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
