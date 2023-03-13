{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  device = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop" "lite"];

  catppuccin = pkgs.fetchzip {
    url = "https://raw.githubusercontent.com/catppuccin/prismlauncher/main/themes/Mocha/Catppuccin-Mocha.zip";
    sha256 = "8uRqCoe9iSIwNnK13d6S4XSX945g88mVyoY+LZSPBtQ=";
  };
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.gaming.enable)) {
    home = {
      # copy the catppuccin theme to the themes directory of PrismLauncher
      file.".local/share/PrismLauncher/themes/mocha" = {
        source = catppuccin;
        recursive = true;
      };

      packages = with pkgs; [
        #gamescope # FIXME: override package wlroots
        legendary-gl
        prismlauncher
        mono
        winetricks
        mangohud
        taisei
        unciv
        # get dotnet runtime 6
        dotnet-runtime_6

        # jre 17
        temurin-jre-bin-17
      ];
    };
  };
}
