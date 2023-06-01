{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader
    ./gaming
    ./cross
    ./system
  ];
}
