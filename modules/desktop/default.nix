{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./programs.nix
    ./services.nix
    #./steam.nix
    ./xserver.nix
  ];
  nixpkgs.overlays = [(import ../overlays)];
}
