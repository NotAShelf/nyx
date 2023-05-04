{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./games
    ./mangohud
    ./steam
    ./obs
  ];
}
