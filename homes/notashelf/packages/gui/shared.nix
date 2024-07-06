{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
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
      bitwarden-desktop

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
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers

      # Okular needs ghostscript to import PostScript files as PDFs
      # so we add ghostscript_headless as a dependency
      (symlinkJoin {
        name = "Okular";
        paths = with pkgs; [
          kdePackages.okular
          ghostscript_headless
        ];
      })

      # gnome packages
      gnome-tweaks
      gnome-calendar
      komikku
    ];
  };
}
