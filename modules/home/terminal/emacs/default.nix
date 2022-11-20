{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
      sha256 = "0mz4032pd3ky51h9q3fxm581naal241wjh9gnvkh72s1jgymka33";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];

  services.emacs = {
    enable = true;
  };
}
