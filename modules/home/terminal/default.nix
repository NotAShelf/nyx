{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./kitty
    ./shell
    ./tools
    ./neovim
    ./mpd
    ./emacs
    ./newsboat
  ];
}
