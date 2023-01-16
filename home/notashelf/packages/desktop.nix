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
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      thunderbird
      lutris
      dolphin-emu
      qbittorrent
      quasselClient
      bitwarden
      obsidian
      nextcloud-client
      #gnome.gnome-control-center # FIXME: fails to build due dependency mismatch
      gnome.gnome-tweaks
      gnome.gnome-calendar
      pavucontrol
      ungoogled-chromium
      easyeffects
      librewolf
    ];
  };
}
