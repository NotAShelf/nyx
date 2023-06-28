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
      schildichat-desktop
      qbittorrent
      hexchat
      netflix
      bitwarden
      obsidian
      nextcloud-client
      udiskie
      (pkgs.symlinkJoin {
        name = "gnome-control-center-wrapped";
        paths = [pkgs.gnome.gnome-control-center];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram "$out/bin/gnome-control-center" --set XDG_CURRENT_DESKTOP gnome
        '';
      })
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
    ];
  };
}
