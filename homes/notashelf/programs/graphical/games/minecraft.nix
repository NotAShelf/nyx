{
  lib,
  pkgs,
  osConfig,
  inputs',
  ...
}: let
  inherit (lib) mkIf;

  sys = osConfig.modules.system;
  env = osConfig.modules.usrEnv;
  prg = sys.programs;

  catppuccin-mocha = pkgs.fetchzip {
    url = "https://raw.githubusercontent.com/catppuccin/prismlauncher/main/themes/Mocha/Catppuccin-Mocha.zip";
    sha256 = "sha256-8uRqCoe9iSIwNnK13d6S4XSX945g88mVyoY+LZSPBtQ=";
  };

  # java packages that are needed by various versions or modpacks
  # different distributions of java may yield different results in performance
  # and thus I recommend testing them one by one to remove those that you do not
  # need in your configuration
  jdks = with pkgs; [
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

  additionalPrograms = with pkgs; [
    gamemode
    mangohud
    jprofiler
  ];

  glfw =
    if env.isWayland
    then pkgs.glfw-wayland-minecraft
    else pkgs.glfw;
in {
  config = mkIf prg.gaming.enable {
    home = {
      # copy the catppuccin theme to the themes directory of PrismLauncher
      file.".local/share/PrismLauncher/themes/mocha" = {
        source = catppuccin-mocha;
        recursive = true;
      };

      packages = [
        # the successor to polyMC, which is now mostly abandoned
        (pkgs.prismlauncher.override {
          # get java versions required by various minecraft versions
          # "write once run everywhere" my ass
          inherit jdks;

          # wrap prismlauncher with programs in may need for workarounds
          # or client features
          inherit additionalPrograms;

          # prismlauncher's glfw version to properly support wayland
          inherit glfw;
        })
      ];
    };
  };
}
