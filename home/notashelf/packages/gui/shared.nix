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
