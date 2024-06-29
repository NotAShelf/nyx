{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig.modules) device;

  cfg = osConfig.modules.style;

  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    xdg.systemDirs.data = let
      schema = pkgs.gsettings-desktop-schemas;
    in ["${schema}/share/gsettings-schemas/${schema.name}"];

    home = {
      packages = [pkgs.glib]; # gsettings

      sessionVariables = {
        # Set GTK_THEME variable to the name of the theme package
        # in our theming module.
        GTK_THEME = cfg.gtk.theme.name;

        # Tell GTK applications to use the file-pickers provided by
        # xdg-desktop-portal-gtk. This gives us a somewhat consistent
        # file picker, and fixes issues with some Flatpak apps that
        # use GTK backend(s).
        GTK_USE_PORTAL = toString (lib.boolToNum cfg.gtk.usePortal);
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = cfg.gtk.theme.name;
        package = cfg.gtk.theme.package;
      };

      iconTheme = {
        name = cfg.gtk.iconTheme.name;
        package = cfg.gtk.iconTheme.package;
      };

      font = {
        name = cfg.gtk.font.name;
        size = cfg.gtk.font.size;
      };

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3.extraConfig = {
        # Lets be easy on the eyes. This should be easy to make dependent on
        # the "variant" of the theme, but I never use a light theme anyway.
        gtk-application-prefer-dark-theme = true;

        # Decorations
        gtk-decoration-layout = "appmenu:none";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;

        # Silence bells and whistles, quite literally.
        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        # Fonts
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };

      gtk4.extraConfig = {
        # Prefer dark theme.
        gtk-application-prefer-dark-theme = true;

        # Decorations.
        gtk-decoration-layout = "appmenu:none";

        # Sounds, again.
        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        # Fonts, you know the drill.
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };
  };
}
