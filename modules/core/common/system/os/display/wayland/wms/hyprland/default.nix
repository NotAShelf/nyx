{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system;
  env = config.modules.usrEnv;

  hyprlandPkg = env.desktops.hyprland.package;
in {
  # disables Nixpkgs Hyprland module to avoid conflicts
  disabledModules = ["programs/hyprland.nix"];

  config = mkIf (sys.video.enable && (env.desktop == "Hyprland" && env.isWayland)) {
    services.displayManager.sessionPackages = [hyprlandPkg];

    xdg.portal = {
      enable = true;
      configPackages = [hyprlandPkg];
      extraPortals = [
        (inputs'.xdg-portal-hyprland.packages.xdg-desktop-portal-hyprland.override {
          hyprland = hyprlandPkg;
        })
      ];
    };
  };
}
