{
  imports = [
    ./environment.nix
    ./systemd.nix
    ./documentation.nix
    ./fonts.nix
    ./programs.nix
    ./users.nix
    ./xdg.nix
  ];

  system.nixos.tags = ["headless"];
}
