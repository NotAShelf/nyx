{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
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
