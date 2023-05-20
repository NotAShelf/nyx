_: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./system.nix
    ./mounts.nix
    ./wireguard.nix
    #./secure-boot.nix # FIXME: no worky
  ];
}
