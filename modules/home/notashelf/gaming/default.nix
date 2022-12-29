{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./gamemode
    ./steam
    ./obs
  ];
}
