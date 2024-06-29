{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  env = osConfig.modules.usrEnv;
in {
  # If desktop is not set, then assume tray is not necessary.
  config = mkIf (env.desktop != "") {
    # fake a tray to let apps start
    # https://github.com/nix-community/home-manager/issues/2064
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
