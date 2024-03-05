{
  imports = [
    ./modules
    ./fs

    ./networking.nix
    ./system.nix
    ./wireguard.nix # TODO: abstract
  ];
}
