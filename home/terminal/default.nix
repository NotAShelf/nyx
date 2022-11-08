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
    ./kitty
    ./shell
    ./tmux
    ./tools
  ];

}
