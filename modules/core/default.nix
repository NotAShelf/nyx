{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system.nix
    ./security.nix
    ./network.nix
    ./nix.nix
    ./users.nix
    ./openssh.nix
    ./blocker.nix
  ];
}
