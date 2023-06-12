{
  pkgs,
  lib,
  config,
  inputs,
  self,
  osConfig,
  ...
}:
with lib; let
  hyprshot = pkgs.writeShellScriptBin "hyprshot" ''
    #!/bin/bash
    hyprctl keyword animation "fadeOut,0,8,slow" && ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5e81acd2)" - | swappy -f -; hyprctl keyword animation "fadeOut,1,8,slow"
  '';
  hyprpicker = inputs.hyprpicker.packages.${pkgs.system}.default;
  hyprland-share-picker = inputs.xdg-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;

  env = osConfig.modules.usrEnv;
  device = osConfig.modules.device;
  sys = osConfig.modules.system;
in {
  imports = [./config.nix];
  config = mkIf ((sys.video.enable) && (env.isWayland && (env.desktop == "Hyprland"))) {
    home.packages = [
      hyprshot
      grimblast
      hyprpicker
      hyprland-share-picker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      package = inputs.hyprland.packages.${pkgs.system}.default.override {
        nvidiaPatches = (device.gpu == "nvidia") || (device.gpu == "hybrid-nv");
      };
    };
  };
}
