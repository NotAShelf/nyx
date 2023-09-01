{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = lib.mkIf osConfig.modules.usrEnv.programs.thunderbird.enable {
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
