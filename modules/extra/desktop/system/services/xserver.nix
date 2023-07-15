{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  sys = config.modules.system;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf ((sys.video.enable) && (builtins.elem device.type acceptedTypes)) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = false;
      displayManager.lightdm.enable = false;
    };
  };
}
