{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str package int;
in {
  options = {
    modules = {
      style = {
        # Theming options for GTK programs. Will be passed verbatim to home-manager
        # in some cases.
        gtk = {
          enable = mkEnableOption "GTK theming options";
          usePortal = mkEnableOption "native desktop portal use for filepickers";

          theme = {
            name = mkOption {
              type = str;
              default = "catppuccin-mocha-blue-standard+normal";
              description = "The name for the GTK theme package";
            };

            package = mkOption {
              type = package;
              description = "The theme package to be used for GTK programs";
              default = pkgs.catppuccin-gtk.override {
                size = "standard";
                variant = "mocha";
                accents = ["blue"];
                tweaks = ["normal"];
              };
            };
          };

          iconTheme = {
            name = mkOption {
              type = str;
              description = "The name for the icon theme that will be used for GTK programs";
              default = "Papirus-Dark";
            };

            package = mkOption {
              type = package;
              description = "The GTK icon theme to be used";
              default = pkgs.catppuccin-papirus-folders.override {
                accent = "blue";
                flavor = "mocha";
              };
            };
          };

          font = {
            name = mkOption {
              type = str;
              description = "The name of the font that will be used for GTK applications";
              default = "Lexend";
            };

            size = mkOption {
              type = int;
              description = "The size of the font";
              default = 14;
            };
          };
        };
      };
    };
  };
}
