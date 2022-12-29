{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./steam
    ./obs
  ];
}
