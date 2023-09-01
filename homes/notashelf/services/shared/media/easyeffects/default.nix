{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (isAcceptedDevice osConfig acceptedTypes) {
    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
    services.easyeffects = {
      enable = true;
      preset = "quiet";
    };
  };
}
