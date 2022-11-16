{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./services.nix
    ./bootloader.nix
    ./security.nix
    ./bootloader.nix
    ./users.nix
    ./programs.nix
  ];
}
