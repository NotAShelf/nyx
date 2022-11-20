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
    #./xserver.nix
  ];
}
