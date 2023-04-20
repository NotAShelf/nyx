{
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib; let
  texlive = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small
      noto
      mweights
      cm-super
      cmbright
      fontaxes
      beamer
      ;
  };
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = [texlive pkgs.pandoc];
  };
}
