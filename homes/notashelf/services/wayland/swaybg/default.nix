{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
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
            sha256 = lib.fakeHash;
          };
        in {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${wall}";
          Restart = "always";
        };
      };
    };
  };
}
