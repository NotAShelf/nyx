{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) either listOf package str int bool;
in {
  imports = [
    ./gtk.nix
    ./qt.nix
    ./colors.nix
  ];

  options.modules.style = {
    forceGtk = mkOption {
      type = bool;
      default = false;
      description = "Whether to force QT applications to try and use the GTK theme.";
    };

    useKvantum = mkOption {
      type = bool;
      default = false;
      description = "Whether to use Kvantum for theming QT applications";
    };

    pointerCursor = {
      package = mkOption {
        type = package;
        default = pkgs.catppuccin-cursors.mochaDark;
        description = "The package providing the cursors";
      };

      name = mkOption {
        type = str;
        default = "catppuccin-mocha-dark-cursors";
        description = "The name of the cursor inside the package";
      };

      size = mkOption {
        type = int;
        default = 24;
        description = "The size of the cursor";
      };
    };

    wallpapers = mkOption {
      type = either str (listOf str);
      default = [];
      description = "Wallpaper or wallpapers to use";
    };
  };
}
