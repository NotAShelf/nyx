{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./editors
    ./kitty
    ./shell
    ./tools
    ./newsboat
    ./foot
    ./bottom
    ./ranger
    ./wezterm
    ./pandoc
  ];
}
