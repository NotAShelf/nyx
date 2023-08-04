{lib, ...}: let
  inherit (lib) mkEnableOption mdDoc;
in {
  options.modules.system.security = {
    fixWebcam = mkEnableOption (mdDoc "Fix the purposefully broken webcam by un-blacklisting the related kernel module.");
    secureBoot = mkEnableOption (mdDoc "Enable secure-boot and load necessary packages.");
    tor.enable = mkEnableOption (mdDoc "Tor daemon");
  };
}
