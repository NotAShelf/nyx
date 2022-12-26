{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./gtk
    ./hyprland
    ./webcord
    ./dunst
    ./rofi
    ./swaylock
    ./waybar
    ./schizofox
    ./zathura
    ./office
    inputs.hyprland.homeManagerModules.default
  ];
}
