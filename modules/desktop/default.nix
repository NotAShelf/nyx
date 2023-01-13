{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader
    ./gaming
    ./xdg-ninja
    ./cross

    ./programs.nix
    ./services.nix
    ./system.nix
    ./xserver.nix
    ./tor.nix
    ./fonts.nix
  ];
}
