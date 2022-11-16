{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./services.nix
    ./bootloader.nix
    ./security.nix
    ./bootloader.nix
    ./users.nix
  ];
  nixpkgs.overlays = [inputs.emacs-overlay.overlay];
}
