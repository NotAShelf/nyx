_: {
  imports = [
    ./hardware-configuration.nix
    ./ragenix.nix
    ./system.nix
    ./mounts.nix
    ./wireguard.nix
    #./secure-boot.nix # FIXME: no worky
  ];
}
