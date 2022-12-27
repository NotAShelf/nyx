{
  inputs,
  self,
  ...
}: {
  imports = [
    ./gtk
    ./hyprland
    ./webcord
    ./rofi
    ./schizofox
    ./zathura
    ./office
    inputs.hyprland.homeManagerModules.default
  ];
}
