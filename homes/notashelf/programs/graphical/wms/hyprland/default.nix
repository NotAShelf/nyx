{
  pkgs,
  lib,
  osConfig,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (import ./packages.nix {inherit pkgs;}) hyprshot dbus-hyprland-env;
  inherit (inputs'.hyprland-contrib.packages) grimblast;

  hyprpicker = inputs'.hyprpicker.packages.default;

  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
in {
  imports = [./config.nix];
  config = mkIf (sys.video.enable && (env.isWayland && (env.desktop == "Hyprland"))) {
    home.packages = [
      hyprshot
      grimblast
      hyprpicker
      dbus-hyprland-env
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.default;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}
