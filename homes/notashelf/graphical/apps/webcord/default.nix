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
    rev = "d4a7027faeb4abef59aee9362504699d92751fbc";
    hash = "sha256-ZSuvGzQqJj/EZBmB2F0hqd9TBNtUoaHTijn/z9ujRVg=";
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
