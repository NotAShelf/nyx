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
    #./mako
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
