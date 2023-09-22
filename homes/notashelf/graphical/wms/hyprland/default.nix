{
  pkgs,
  lib,
  osConfig,
  inputs',
  ...
}:
with lib; let
  hyprshot = pkgs.writeShellScriptBin "hyprshot" ''
    #!/bin/bash
    hyprctl keyword animation "fadeOut,0,8,slow" && ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5e81acd2)" - | swappy -f -; hyprctl keyword animation "fadeOut,1,8,slow"
  '';
  hyprpicker = inputs'.hyprpicker.packages.default;
  grimblast = inputs'.hyprland-contrib.packages.grimblast;

  env = osConfig.modules.usrEnv;
  device = osConfig.modules.device;
  sys = osConfig.modules.system;
in {
  imports = [./config.nix];
  config = mkIf (sys.video.enable && (env.isWayland && (env.desktop == "Hyprland"))) {
    home.packages = [
      hyprshot
      grimblast
      hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      package = inputs'.hyprland.packages.default.override {
        enableNvidiaPatches = (device.gpu == "nvidia") || (device.gpu == "hybrid-nv");
      };
    };
  };
}
