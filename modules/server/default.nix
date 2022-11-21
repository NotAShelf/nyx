{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./services.nix
    ./bootloader.nix
    ./security.nix
    ./users.nix
    ./programs.nix
  ];
}
