{
  lib,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
    services.easyeffects = {
      enable = true;
      preset = "quiet";
    };
  };
}
