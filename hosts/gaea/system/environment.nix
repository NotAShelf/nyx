{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  # borrow some environment options from the minimal profile to save space
  environment = {
    noXlibs = mkDefault true; # trim inputs

    # no packages other than my defaults
    defaultPackages = mkForce [];

    # system packages for the base installer
    systemPackages = with pkgs; [
      nixos-install-tools
      gitMinimal
      neovim
      netcat
    ];

    # fix an annoying warning
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };
}
