{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  imports = [
    ./gtk
    ./mako
    ./rofi
    ./swaylock
    ./waybar
    ./zathura
    ./hyprland
    inputs.hyprland.homeManagerModules.default
  ];
}
