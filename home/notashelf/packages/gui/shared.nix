{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      thunderbird
      qbittorrent
      quasselClient
      bitwarden
      obsidian
      nextcloud-client
      udiskie
      gnome.gnome-control-center
      gnome.gnome-tweaks
      gnome.gnome-calendar
      ungoogled-chromium
      easyeffects
      librewolf
      zoom-us # I hate this
      cinnamon.nemo
      brightnessctl # move
      pamixer # move
      tesseract5 # move
    ];
  };
}
