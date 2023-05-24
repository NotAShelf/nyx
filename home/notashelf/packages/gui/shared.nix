{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;

  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((programs.gui.enable) && (builtins.elem device.type acceptedTypes)) {
    home.packages = with pkgs; [
      schildichat-desktop-wayland
      thunderbird
      qbittorrent
      hexchat
      netflix
      spotify-wrapped
      bitwarden
      obsidian
      nextcloud-client
      udiskie
      gnome.gnome-control-center
      gnome.gnome-tweaks
      gnome.gnome-calendar
      easyeffects
      librewolf
      zoom-us # I hate this
      cinnamon.nemo
      brightnessctl # move
      tesseract5 # move
      pamixer # move
      dolphin
      plasma5Packages.kio
      plasma5Packages.kio-extras
      plasma5Packages.kimageformats
      plasma5Packages.kdegraphics-thumbnailers
    ];
  };
}
