{
  osConfig,
  lib,
  ...
}:
with lib; let
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      nextcloud-client.enable = true;
      nextcloud-client.startInBackground = true;
    };
  };
}
