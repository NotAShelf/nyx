{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.modules.style;
in {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

  options = {
    modules = {
      style = {
        forceGtk = mkEnableOption "Force GTK applications to use the GTK theme";
        useKvantum = mkEnableOption "Use Kvantum to theme QT applications";

        # choose a colorscheme
        colorScheme = {
          # "Name Of The Scheme"
          name = mkOption {
            type = with types; nullOr (enum (import ./palettes.nix));
            description = "The colorscheme that should be used globally to theme your system.";
            default = "Catppuccin Mocha";
          };

          # "name-of-the-scheme"
          slug = mkOption {
            type = types.str;
            default = lib.serializeTheme "${toString cfg.colorScheme.name}"; # toString to avoid type errors if null
            description = ''
              The serialized slug for the colorScheme you are using.

              Defaults to a lowercased version of the theme name with spaces
              replaced with hyphens.

              Must only be changed if the slug is expected to be different than
              the serialized theme name."
            '';
          };
        };

        pointerCursor = {
          package = mkOption {
            type = types.package;
            description = "The package providing the cursors";
            default = pkgs.catppuccin-cursors.mochaDark;
          };

          name = mkOption {
            type = types.str;
            description = "The name of the cursor inside the package";
            default = "Catppuccin-Mocha-Dark-Cursors";
          };

          size = mkOption {
            type = types.int;
            description = "The size of the cursor";
            default = 24;
          };
        };

        wallpapers = mkOption {
          type = with types; (either ((listOf str) str));
          description = "Wallpaper or wallpapers to use";
          default = [
            "${pkgs.catppuccino-wallpapers}/share/backgrounds/catppuccino-mocha.png"
          ];
        };
      };
    };
  };
}
