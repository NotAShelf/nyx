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
    ./cnvim
    ./newsboat
    ./foot
    ./helix
    ./bottom
    ./ranger
    ./wezterm
  ];
}
