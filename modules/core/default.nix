{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./blocker.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./users.nix
  ];
}
