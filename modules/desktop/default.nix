{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./programs.nix
    ./services.nix
    ./nvidia.nix
    #./steam.nix
    ./xserver.nix
  ];
}
