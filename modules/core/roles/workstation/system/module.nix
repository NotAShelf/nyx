{
  imports = [
    ./programs
    ./services
    ./security

    ./fonts.nix
    ./misc.nix
  ];

  system.nixos.tags = ["workstation"];
}
