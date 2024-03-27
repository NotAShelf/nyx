{
  imports = [
    ./fs
    ./kernel
    ./modules

    ./btrfs.nix
    ./networking.nix
    ./system.nix
    ./wireguard.nix # TODO: abstract
  ];
}
