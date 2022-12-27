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
    ./vimuwu
    ./emacs
    ./newsboat
    ./foot
    ./helix
    ./bottom
  ];
}
