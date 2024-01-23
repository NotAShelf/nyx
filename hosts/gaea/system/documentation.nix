{lib, ...}: let
  inherit (lib) mkDefault;
in {
  # disable documentation to save space
  documentation = {
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
  };
}
