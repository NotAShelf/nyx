{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  webcord-vencord = pkgs.webcord-vencord.override {
    flags = let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        rev = "dfd6b75c3fd4487850d11e83e64721f2113d0867";
        sha256 = "sha256-rfySizeEko9YcS+SIl2u6Hulq1hPnPoe8d6lnD15lPI=";
      };
      theme = "${catppuccin}/themes/mocha.theme.css";
    in ["--add-css-theme=${theme}"];
  };

  /*
  webcord = inputs.webcord.packages.${pkgs.system}.default.override {
    flags = let
      theme = "${catppuccin}/themes/mocha.theme.css";
    in ["--add-css-theme=${theme}"];
  };
  */

  device = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = [
      webcord-vencord
    ];
  };
}
