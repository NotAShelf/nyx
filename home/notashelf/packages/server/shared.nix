{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;

  device = osConfig.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((programs.cli.enable) && (builtins.elem device.type acceptedTypes)) {
    home.packages = with pkgs; [
      wireguard-tools
    ];
  };
}
