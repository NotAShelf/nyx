{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  dev = modules.device;
  sys = modules.system;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (sys.video.enable && (builtins.elem dev.type acceptedTypes)) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = false;
      displayManager.lightdm.enable = false;
    };
  };
}
