{
  imports = [
    ./nix
    ./os
    ./security
  ];

  system.nixos.tags = ["microvm"];
}
