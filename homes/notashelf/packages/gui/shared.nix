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

      # Obsidian has a pandoc plugin that allows us to render and export
      # alternative image format, but as the name indicates the plugin
      # requires `pandoc` binary to be accessiblee. Join pandoc derivation
      # to Obsidian to make it available to satisfy the dependency.
      (symlinkJoin {
        name = "Obsidian";
        paths = with pkgs; [
          obsidian
          pandoc
        ];
      })

      # plasma packages
      plasma5Packages.dolphin
      plasma5Packages.dolphin-plugins
      plasma5Packages.kio
      plasma5Packages.kio-extras
      plasma5Packages.kimageformats
      plasma5Packages.kdegraphics-thumbnailers

      # Okular needs ghostscript to import PostScript files as PDFs
      # so we add ghostscript_headless as a dependency
      (symlinkJoin {
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
