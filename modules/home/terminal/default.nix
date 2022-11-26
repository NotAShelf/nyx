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

  modules = {
    programs = {
      vimuwu.enable = true;
    };
  };
}
