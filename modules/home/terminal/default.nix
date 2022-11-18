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
    ./neovim
    ./mpd
  ];
  config.modules = {
    programs = {
      vimuwu.enable = true;
    };
  };
}
