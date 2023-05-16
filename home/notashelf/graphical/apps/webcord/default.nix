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
    rev = "3b6a4a2f69253dc7d5ea93317d7dce9a0ef24589";
    sha256 = "OugXRMSXbb3DDyrrmTIvYFlD0Kc/KU37OWoEPOpa8z8=";
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

    xdg.configFile."WebCord/Themes/mocha" = {
      source = "${catppuccin-mocha}/themes/mocha.theme.css";
    };

    services.arrpc.enable = true;
  };
}
