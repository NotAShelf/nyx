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
      hexchat
      netflix
      helvum

      # Electron applications
      # zoom-us # may we never return to online education
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
      plasma5Packages.okular

      # gnome packages
      gnome.gnome-tweaks
      gnome.gnome-calendar
      komikku

      # override gnome-control-center to trick it into thinking we're running gnome
      # <https://github.com/NixOS/nixpkgs/issues/230493>
      # <https://gitlab.gnome.org/GNOME/gnome-control-center/-/merge_requests/736>
      # get overridden idiot
      /*
      (gnome.gnome-control-center.overrideAttrs
        (old: {
          # gnome-control-center does not start without XDG_CURRENT_DESKTOP=gnome
          preFixup =
            ''
              gappsWrapperArgs+=(
                --set XDG_CURRENT_DESKTOP "gnome"
              );
            ''
            + old.preFixup;
        }))
      */
    ];
  };
}
