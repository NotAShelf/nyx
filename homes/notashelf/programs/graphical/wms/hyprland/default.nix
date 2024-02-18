{
  inputs',
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe';
  inherit (osConfig) modules;
  inherit (inputs') hyprland;
  inherit (import ./packages.nix {inherit inputs' pkgs;}) grimblast hyprshot dbus-hyprland-env hyprpicker;

  env = modules.usrEnv;

  # I blame home manager
  wrapper = pkgs.callPackage (_:
    pkgs.writeShellScriptBin "hyprland" ''
      ${builtins.readFile ./session.sh}
      ${getExe' hyprland.packages.default "Hyprland"} $@
    '') {};
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
      package = wrapper;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}
