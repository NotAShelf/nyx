{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = lib.mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && osConfig.modules.usrEnv.programs.cli.whitehat.enable) {
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
