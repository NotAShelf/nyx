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
    ./mpv
    inputs.hyprland.homeManagerModules.default
  ];
}
