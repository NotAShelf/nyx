{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./blocker.nix
    ./bootloader.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./users.nix
  ];
}
