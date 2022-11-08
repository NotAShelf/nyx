{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  home.stateVersion = "22.09";
  imports = [
    ./packages.nix
    ./gtk
    ./kitty
    ./mako
    ./rofi
    ./shell
    ./swaylock
    ./tmux
    ./tools
    ./waybar
    ./zathura
    ./hyprland
    inputs.hyprland.homeManagerModules.default
  ];
}
