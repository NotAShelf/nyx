{
  inputs,
  self,
  ...
}: {
  imports = [
    #./vscode # FIXME breaks due to some stupid extension dependency issue
    ./hyprland
    ./webcord
    ./rofi
    ./schizofox
    ./zathura
    ./office
    ./mpv
  ];
}
