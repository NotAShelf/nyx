{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.modules) device;
  cfg = osConfig.modules.style;

  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    xdg.systemDirs.data = let
      schema = pkgs.gsettings-desktop-schemas;
    in ["${schema}/share/gsettings-schemas/${schema.name}"];

    home = {
      packages = with pkgs; [
        glib # gsettings
        cfg.gtk.theme.package
        cfg.gtk.iconTheme.package
      ];

      sessionVariables = {
        # set GTK theme to the name specified by the gtk theme package
        GTK_THEME = "${cfg.gtk.theme.name}";

        # gtk applications should use filepickers specified by xdg
        GTK_USE_PORTAL = "${toString (lib.boolToNum cfg.gtk.usePortal)}";
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
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-decoration-layout = "appmenu:none";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-error-bell = 0;
        gtk-application-prefer-dark-theme = true;
      };

      gtk4.extraConfig = {
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-error-bell = 0;
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}
