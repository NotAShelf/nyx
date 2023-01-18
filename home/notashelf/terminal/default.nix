{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    #./kitty
    ./shell
    ./tools
    ./cnvim
    ./emacs
    ./newsboat
    ./foot
    ./helix
    ./bottom
    ./ranger
  ];
}
