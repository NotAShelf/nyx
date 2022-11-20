{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./kitty
    ./shell
    ./tmux
    ./tools
    ./neovim
    ./mpd
    ./emacs
  ];
  config.modules = {
    programs = {
      neovim.enable = true;
    };
  };
}
