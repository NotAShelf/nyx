{lib, ...}: let
  inherit (lib) mkDefault;
in {
  # I don't use lvm, can be disabled
  services.lvm.enable = mkDefault false;
}
