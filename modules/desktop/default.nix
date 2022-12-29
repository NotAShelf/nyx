{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./xdg-ninja
    ./gamemode.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./bootloader.nix
    ./xserver.nix
    ./tor.nix
  ];
}
