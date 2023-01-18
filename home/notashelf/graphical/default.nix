{
  inputs,
  self,
  ...
}: {
  imports = [
    #./vscode
    ./hyprland
    ./webcord
    ./rofi
    ./schizofox
    ./zathura
    ./office
    ./mpv
    inputs.hyprland.homeManagerModules.default
  ];
}
