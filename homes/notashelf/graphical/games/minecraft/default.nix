{
  lib,
  pkgs,
  osConfig,
  inputs',
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

  javaPackages = with pkgs; [
    # Java 8
    temurin-jre-bin-8
    zulu8
    # Java 11
    temurin-jre-bin-11
    # Java 17
    temurin-jre-bin-17
    # Latest
    temurin-jre-bin
    zulu
    graalvm-ce
  ];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && programs.gaming.enable) {
    home = {
      # copy the catppuccin theme to the themes directory of PrismLauncher
      file.".local/share/PrismLauncher/themes/mocha" = {
        source = catppuccin-mocha;
        recursive = true;
      };

      packages = [
        # the successor to polyMC, which is now mostly abandoned
        (inputs'.prism-launcher.packages.prismlauncher.override {
          # get java versions required by various minecraft versions
          # "write once run everywhere" my ass
          jdks = javaPackages;
          additionalPrograms = with pkgs; [gamemode mangohud];
        })
      ];
    };
  };
}
