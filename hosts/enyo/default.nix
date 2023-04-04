_: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./mounts.nix
    #./wireguard.nix
    #./secure-boot.nix # FIXME: no worky
    #./ragenix.nix
  ];
}
