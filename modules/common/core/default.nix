_: {
  imports = [
    ./nix # configuration for the nix package manager and build tool
    ./impermanence # impermanence configuration
    ./secrets # secrets management
    ./system # system configurations, from bootloader to desktop environment
  ];
}
