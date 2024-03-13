{
  imports = [
    ./modules
    ./fs

    ./btrfs.nix
    ./networking.nix
    ./system.nix
    ./wireguard.nix # TODO: abstract
  ];
}
