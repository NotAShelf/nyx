{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./services.nix
  ];
  nixpkgs.overlays = [inputs.emacs-overlay.overlay];
}
