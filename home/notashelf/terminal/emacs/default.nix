{
  pkgs,
  inputs,
  ...
}: let
  doom-emacs = pkgs.callPackage inputs.nix-doom-emacs {
    doomPrivateDir = ./doom.d;
  };
in {
  config = {
    home.packages = [doom-emacs];
    services.emacs = {
      enable = true;
    };
  };
}
