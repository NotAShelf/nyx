{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./programs.nix
    ./services.nix
    ./steam.nix
    ./system.nix
    ./xserver.nix
  ];
}
