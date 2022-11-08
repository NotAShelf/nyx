{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./gtk
    ./mako
    ./rofi
    ./swaylock
    ./waybar
    ./zathura
    ./hyprland
  ];

}
