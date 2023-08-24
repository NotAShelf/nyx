{
  config,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  inherit (osConfig.modules) device;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  imports = [inputs.schizofox.homeManagerModules.default];
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.schizofox = {
      enable = true;
    };
  };
}
