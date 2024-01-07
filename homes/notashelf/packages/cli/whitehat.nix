{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
  prg = osConfig.modules.programs;
  dev = osConfig.modules.device;
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.cli.enable) {
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
