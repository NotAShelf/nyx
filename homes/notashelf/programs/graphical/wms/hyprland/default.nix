{
  pkgs,
  lib,
  osConfig,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (import ./packages.nix {inherit inputs' pkgs;}) grimblast hyprshot dbus-hyprland-env hyprpicker;

  env = modules.usrEnv;
in {
  imports = [./config.nix];
  config = mkIf env.desktops.hyprland.enable {
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
