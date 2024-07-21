{
  imports = [
    ./services

    ./environment.nix
  ];

  system.nixos.tags = ["server"];
}
