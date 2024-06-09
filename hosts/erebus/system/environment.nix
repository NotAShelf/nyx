{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  environment = {
    noXlibs = mkForce false;

    systemPackages = with pkgs; [
      # Yubikey tooling
      yubikey-personalization
      cryptsetup
      pwgen
      paperkey
      gnupg
      ctmg

      # GUI tools
      alacritty # terminal emulator
      zathura # PDF viewer
      imv # image viewer
    ];

    # fix an annoying warning
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };
}
