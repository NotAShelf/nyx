{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
    services.easyeffects = {
      enable = true;
      preset = "quiet";
    };
  };
}
