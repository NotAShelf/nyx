{osConfig, ...}: let
  cfg = osConfig.modules.style;
  inherit (cfg.pointerCursor) package name size;
in {
  home.pointerCursor = {
    # Package, name and the size of the cursor. The same values need to be set
    # in Hyprland config to make sure our cursors are consistent.
    inherit package name size;

    # Enable GTK config generation for pointerCursor
    gtk.enable = true;

    # Enable X11 config generation for pointerCursor
    x11.enable = true;
  };
}
