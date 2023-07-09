{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [thunderbird];

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {};
        userChrome = "";
        userContent = "";
        withExternalGnupg = true;
      };
    };
  };
}
