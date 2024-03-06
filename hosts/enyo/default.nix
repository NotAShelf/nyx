{
  imports = [
    ./modules
    ./fs

    ./btrfs.nix
    ./kernel.nix
    ./networking.nix
    ./system.nix
    ./wireguard.nix # TODO: abstract
  ];
}
