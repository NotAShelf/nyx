{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) pathExists;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str package int;

  cfg = config.modules.style.gtk;
in {
  # Theming options for GTK programs. Will be passed verbatim to home-manager
  # in some cases.
  options.modules.style.gtk = {
    enable = mkEnableOption "GTK theming options";
    usePortal = mkEnableOption "native desktop portal use for filepickers [xdg-desktop-portal-gtk]";

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
          variant = "mocha";
          size = "standard";
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

  config = {
    assertions = [
      (let
        themePath = cfg.theme.package + /share/themes + "/${cfg.theme.name}";
      in {
        assertion = cfg.enable -> pathExists themePath;
        message = ''
          ${toString themePath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.modules.style.gtk.theme.package` contains
          the path `${cfg.theme.name}`
        '';
      })
    ];
  };
}
