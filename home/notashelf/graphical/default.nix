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
    ./vscode
    inputs.hyprland.homeManagerModules.default
  ];
}
