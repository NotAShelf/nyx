{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "c04f4bd43e571c19551e0e5da2d534408438564c";
    hash = "sha256-3uEVrR2T39Pj0puUwUPuUfXcCPoOq2lNHL8UpppTOiU=";
  };

  device = osConfig.modules.device;
  video = osConfig.modules.system.video;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  imports = [
    inputs.arrpc.homeManagerModules.default
  ];

  config = mkIf ((builtins.elem device.type acceptedTypes) && (video.enable)) {
    home.packages = with pkgs; [
      webcord-vencord # webcord with vencord extension installed
    ];

    xdg.configFile = {
      "WebCord/Themes/mocha" = {
        source = "${catppuccin-mocha}/themes/mocha.theme.css";
      };

      # share my webcord configuration across devices
      # "WebCord/config.json".source = config.lib.file.mkOutOfStoreSymlink "${self}/home/notashelf/graphical/apps/webcord/config.json";
    };

    services.arrpc.enable = true;
  };
}
