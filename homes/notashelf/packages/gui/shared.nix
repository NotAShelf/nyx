{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && sys.video.enable) {
    home.packages = with pkgs; [
      nextcloud-client
      easyeffects
      qbittorrent
      helvum

      # Electron applications
      # zoom-us # may we never return to online education
      netflix
      bitwarden
      (symlinkJoin {
        # wrap obsidian with pandoc for the pandoc plugin dependency
        name = "Obsidian";
        paths = with pkgs; [
          obsidian
          pandoc # pandoc plugin uses pandoc to render alternative text formats
        ];
      })

      # plasma packages
      plasma5Packages.dolphin
      plasma5Packages.dolphin-plugins
      plasma5Packages.kio
      plasma5Packages.kio-extras
      plasma5Packages.kimageformats
      plasma5Packages.kdegraphics-thumbnailers

      (symlinkJoin {
        # wrap obsidian with pandoc for the pandoc plugin dependency
        name = "Okular";
        paths = with pkgs; [
          plasma5Packages.okular
          ghostscript_headless
        ];
      })

      # gnome packages
      gnome.gnome-tweaks
      gnome.gnome-calendar
      komikku
    ];
  };
}
