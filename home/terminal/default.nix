{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  imports = [
    ./kitty
    ./shell
    ./tmux
    ./tools
  ];
}
