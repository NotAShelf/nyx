{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  i3-package = pkgs.i3-rounded;

  cfg = config.modules;
  sys = cfg.system;
  env = cfg.usrEnv;
in {
  config = mkIf (sys.video.enable && (env.desktop == "i3" && !env.isWayland)) {
    services.xserver.displayManager.sessionPackages = [i3-package];
    services.xserver = {
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
      };
    };
  };
}
