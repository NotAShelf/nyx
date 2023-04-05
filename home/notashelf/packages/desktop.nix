{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
  #nicksfetch = self.packages.${pkgs.system}.nicksfetch;
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      thunderbird
      lutris
      dolphin-emu
      yuzu
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
      freecad
      prusa-slicer
      cinnamon.nemo
    ];
  };
}
