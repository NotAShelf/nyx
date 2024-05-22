{
  imports = [
    ./loaders # per-bootloader configurations
    ./secure-boot.nix # secure boot module
    ./generic.nix # generic configuration, such as kernel and tmpfs setup
    ./plymouth.nix # plymouth boot splash
  ];
}
