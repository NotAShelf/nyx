_: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./mounts.nix
    #./secure-boot.nix # FIXME: no worky
    #./ragenix.nix
  ];
}
