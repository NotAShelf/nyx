{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./wayland
    ./xorg
  ];
}
