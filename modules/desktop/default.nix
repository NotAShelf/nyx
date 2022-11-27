{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./xserver.nix
  ];
}
