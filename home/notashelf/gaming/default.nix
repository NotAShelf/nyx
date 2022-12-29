{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./games
    ./steam
    ./obs
  ];
}
