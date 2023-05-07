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

  catppuccin-mocha = pkgs.fetchzip {
    url = "https://raw.githubusercontent.com/catppuccin/prismlauncher/main/themes/Mocha/Catppuccin-Mocha.zip";
    sha256 = "8uRqCoe9iSIwNnK13d6S4XSX945g88mVyoY+LZSPBtQ=";
  };
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.gaming.enable)) {
    programs.mangohud.settings = {};

    home = {
      # copy the catppuccin theme to the themes directory of PrismLauncher
      file.".local/share/PrismLauncher/themes/mocha" = {
        source = catppuccin-mocha;
        recursive = true;
      };

      packages = with pkgs; [
        # the successor to polyMC, which is now mostly abandoned
        #prismlauncher # FIXME: some nixpkgs issue, again

        # jre 17 - needed by newer minecraft versions
        temurin-jre-bin-17
      ];
    };
  };
}