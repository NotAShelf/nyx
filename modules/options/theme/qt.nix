{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) package str;
  cfg = config.modules.style;
in {
  options = {
    modules = {
      style = {
        qt = {
          enable = mkEnableOption "QT Style Module";

          theme = {
            package = mkOption {
              type = package;
              default = pkgs.catppuccin-kde.override {
                flavour = ["mocha"];
                accents = ["blue"];
                winDecStyles = ["modern"];
              };
              description = "The theme package to be used for QT programs";
            };

            name = mkOption {
              type = str;
              default = "Catppuccin-Mocha-Dark";
              description = "The name for the QT theme package";
            };
          };

          kdeglobals.source = mkOption {
            type = str;
            default = "${cfg.qt.theme.package}/share/color-schemes/CatppuccinMochaBlue.colors";
            description = "The source file for the kdeglobals file. Usually provided by the qt theme package";
          };
        };
      };
    };
  };
}
