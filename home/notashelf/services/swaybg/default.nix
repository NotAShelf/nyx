{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
in {
  config = mkIf ((sys.video.enable) && (env.isWayland && (env.desktop != "Hyprland"))) {
    systemd.user.services = {
      swaybg = lib.mkGraphicalService {
        Unit.Description = "Wallpaper chooser service";
        Service = let
          wall = builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/wallpapers/catppuccin/01.png";
            sha256 = "";
          };
        in {
          ExecStart = "${lib.getExe pkgs.hyprpaper} -i ${wall}";
          Restart = "always";
        };
      };
    };
  };
}
