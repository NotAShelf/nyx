{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader
    ./gaming
    ./xdg-ninja

    ./programs.nix
    ./services.nix
    ./system.nix
    ./xserver.nix
    ./tor.nix
  ];
}
