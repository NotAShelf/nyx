{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.emacs-overlay.overlay];
  environment.systemPackages = with pkgs; [
    pkgs.emacs-overlay
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
  };
}
