{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;
  inherit (osConfig) modules;

  inherit (import ./packages {inherit inputs' pkgs;}) grimblast hyprshot dbus-hyprland-env hyprpicker wrapper;

  env = modules.usrEnv;
in {
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./config))
  );
  config = mkIf env.desktops.hyprland.enable {
    home.packages = [
      inputs'.hyprland.packages.hyprland
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
