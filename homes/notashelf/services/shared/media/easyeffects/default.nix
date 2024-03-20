{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    services.easyeffects = {
      enable = true;
      preset = "quiet";
    };

    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
  };
}
