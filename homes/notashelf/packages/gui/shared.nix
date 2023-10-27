{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;

  device = osConfig.modules.device;
  sys = osConfig.modules.system;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((programs.gui.enable && sys.video.enable) && (builtins.elem device.type acceptedTypes)) {
    home.packages = with pkgs; [
      schildichat-desktop
      qbittorrent
      hexchat
      netflix
      bitwarden
      obsidian
      nextcloud-client
      gnome.gnome-tweaks
      gnome.gnome-calendar
      easyeffects
      librewolf
      # zoom-us # I hate this
      cinnamon.nemo
      plasma5Packages.dolphin
      plasma5Packages.dolphin-plugins
      plasma5Packages.kio
      plasma5Packages.kio-extras
      plasma5Packages.kimageformats
      plasma5Packages.kdegraphics-thumbnailers

      # override gnome-control-center to trick it into thinking we're running gnome
      # <https://github.com/NixOS/nixpkgs/issues/230493>
      # <https://gitlab.gnome.org/GNOME/gnome-control-center/-/merge_requests/736>
      # get overriden idiot
      gnome-control-center.overrideAttrs
      (upstream: {
        # gnome-control-center does not start without XDG_CURRENT_DESKTOP=gnome
        preFixup =
          ''
            gappsWrapperArgs+=(
              --set XDG_CURRENT_DESKTOP "gnome"
            );
          ''
          + upstream.preFixup;
      })
    ];
  };
}
