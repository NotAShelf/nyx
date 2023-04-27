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
in {
  config = lib.mkIf ((sys.video.enable) && (env.isWayland && (env.desktop == "Hyprland"))) {
    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        Requires = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe hyprpaper}";
        Restart = "on-failure";
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
    xdg.configFile."hypr/hyprpaper.conf" = {
      text = let
        path = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/notashelf/wallpkgs/main/wallpapers/catppuccin/01.png";
          sha256 = "0srl821d00q3pz7cvks5jrpm253kvxrhkk4m78iskmr8faahai1b";
        };
      in ''
        preload=${path}
        ${builtins.concatStringsSep "\n" (builtins.map (monitor: ''wallpaper=${monitor},${path}'') monitors)}
        ipc=off
      '';
    };
  };
}
