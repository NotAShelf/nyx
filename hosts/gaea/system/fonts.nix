{lib, ...}: let
  inherit (lib) mkForce;
in {
  # disable fontConfig to save space, we don't have a graphical environment on the ISO
  fonts.fontconfig.enable = mkForce false;
}
