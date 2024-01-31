{
  imports = [
    ./modules
    ./fs

    ./networking.nix
    ./hardware.nix # TODO: remove
    ./wireguard.nix # TODO: abstract
  ];
}
