{
  imports = [
    ./gnome.nix
    ./location.nix
    ./printing.nix
    ./xserver.nix # TODO: find a suitable condition for enable
    ./misc.nix
    ./login.nix
    ./runners.nix
  ];
}
