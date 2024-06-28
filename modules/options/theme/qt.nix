{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) package str;

  cfg = config.modules.style.qt;
in {
  options.modules.style.qt = {
    enable = mkEnableOption "QT Style Module";
    theme = {
      package = mkOption {
        type = package;
        default = pkgs.catppuccin-kde.override {
          flavour = ["mocha"];
          accents = ["blue"];
          winDecStyles = ["modern"];
        };

        description = ''
          The theme package to be used for QT programs.

          This package will be used to acquire source files
          for program themes, and as such it should always
          contain conventional theming related filepaths.
        '';
      };

      name = mkOption {
        type = str;
        default = "Catppuccin-Mocha-Dark";
        description = "The name for the QT theme package";
      };
    };

    # Additional sources for theme packages.
    kvantum = {
      package = mkOption {
        type = package;
        default = pkgs.catppuccin-kvantum.override {
          accent = "Blue";
          variant = "Mocha";
        };

        description = ''
          Path to the kvantum theme package to be used for QT programs.
        '';
      };

      kvconfig = mkOption {
        type = str;
        default = "${cfg.kvantum.package}/share/Kvantum/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.kvconfig";
        description = ''
          Path to the kvantum theme package to be used
          for QT programs (configuration).
        '';
      };

      svg = mkOption {
        type = str;
        default = "${cfg.kvantum.package}/share/Kvantum/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.svg";
        description = ''
          Path to the kvantum theme package to be used
          for QT programs (vectors).
        '';
      };
    };

    kdeglobals = {
      package = mkOption {
        type = str;
        default = "${cfg.theme.package}/share/color-schemes/CatppuccinMochaBlue.colors";
        description = "The source file for the kdeglobals file. Usually provided by the qt theme package";
      };

      colors = mkOption {
        type = str;
        default = "${cfg.theme.package}/share/color-schemes/CatppuccinMochaBlue.colors";
        description = "The source file for the kdeglobals file. Usually provided by the qt theme package";
      };
    };
  };
}
