{
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}: let
  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;

  monitors = osConfig.modules.device.monitors;

  hyprpaper = inputs.hyprpaper.packages.${pkgs.system}.default;
  wallpkgs = inputs.wallpkgs.packages.${pkgs.system};
in {
  config = lib.mkIf ((sys.video.enable) && (env.isWayland && (env.desktop == "Hyprland"))) {
    systemd.user.services.hyprpaper = lib.mkHyprlandService {
      Unit.Description = "Hyprland wallpaper daemon";
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe hyprpaper}";
        Restart = "on-failure";
      };
    };
    xdg.configFile."hypr/hyprpaper.conf" = {
      text = let
        wallpaper = "${wallpkgs.catppuccin}/share/wallpapers/catppuccin/01.png";
      in ''
        preload=${wallpaper}
        ${builtins.concatStringsSep "\n" (builtins.map (monitor: ''wallpaper=${monitor},${wallpaper}'') monitors)}
        ipc=off
      '';
    };
  };
}
