{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];

  programs = osConfig.modules.programs;
  device = osConfig.modules.device;
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.cli.enable)) {
    home.packages = with pkgs; [
      # CLI
      binwalk
      binutils
      diffoscopeMinimal
      nmap
      nmapsi4
    ];
  };
}
