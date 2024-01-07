{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.programs;

  dev = osConfig.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (prg.cli.enable && (builtins.elem dev.type acceptedTypes)) {
    home.packages = with pkgs; [
      wireguard-tools
    ];
  };
}
