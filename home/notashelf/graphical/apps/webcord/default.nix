{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  webcord = inputs.webcord.packages.${pkgs.system}.default.override {
    flags = let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        rev = "159aac939d8c18da2e184c6581f5e13896e11697";
        sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
      };

      theme = "${catppuccin}/themes/mocha.theme.css";
    in ["--add-css-theme=${theme}"];
  };
  device = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = [webcord];
  };
}
