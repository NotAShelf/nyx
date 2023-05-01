{
  osConfig,
  lib,
  ...
}: let
  env = osConfig.modules.usrEnv;
in {
  imports = [
    ./polkit
    ./dunst
    ./swaylock
    ./swayidle
    #./swaybg
    ./hyprpaper
    ./waybar
    ./media
    ./cloud
  ];

  config = (lib.mkIf env.useHomeManager) {
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
