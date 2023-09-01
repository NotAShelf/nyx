{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  acceptedTypes = ["server" "hybrid"];
in {
  config = lib.mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && osConfig.modules.programs.cli.enable) {
    home.packages = with pkgs; [
      wireguard-tools
    ];
  };
}
