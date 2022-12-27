{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hyprland
    ./webcord
    ./rofi
    ./schizofox
    ./zathura
    ./office
    inputs.hyprland.homeManagerModules.default
  ];
}
