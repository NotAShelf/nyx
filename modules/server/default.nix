{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./virtualization
    ./services.nix
    ./security.nix
    ./users.nix
    ./programs.nix
  ];
}
