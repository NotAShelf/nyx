{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./services.nix
    ./security.nix
    ./users.nix
    ./programs.nix
  ];
}
