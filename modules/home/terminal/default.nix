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
    ./vimuwu
    ./mpd
  ];
  config.modules = {
    programs = {
      vimuwu.enable = true;
    };
  };
}
