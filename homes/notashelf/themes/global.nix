{osConfig, ...}: let
  cfg = osConfig.modules.style;
in {
  # cursor theme
  home = {
    pointerCursor = {
      package = cfg.pointerCursor.package; # pkgs.bibata-cursors;
      name = cfg.pointerCursor.name; # "Bibata-Modern-Classic";
      size = cfg.pointerCursor.size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
