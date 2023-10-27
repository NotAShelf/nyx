_: {
  imports = [
    ./gpg.nix
    ./nix-index.nix
    ./ssh.nix
  ];
  config = {
    services = {
      udiskie.enable = false;
    };
  };
}
