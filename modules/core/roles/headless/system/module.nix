{
  imports = [
    ./environment.nix
    ./systemd.nix
    ./documentation.nix
    ./fonts.nix
    ./nix.nix
    ./programs.nix
    ./users.nix
    ./xdg.nix
  ];

  system.nixos.tags = ["headless"];
}
