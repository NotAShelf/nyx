{
  imports = [
    ./programs
    ./services
    ./security

    ./fonts.nix
  ];

  system.nixos.tags = ["workstation"];
}
