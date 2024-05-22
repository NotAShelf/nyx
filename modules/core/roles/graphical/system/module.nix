{
  imports = [
    ./security
    ./services

    ./environment.nix
  ];

  system.nixos.tags = ["graphical"];
}
