{
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  sys = osConfig.modules.system;
in {
  config = mkIf ((programs.cli.enable) && (sys.virtualization.podman.enable)) {
    home.packages = with pkgs; [
      # CLI
      docker-compose
      docker-credential-helpers
    ];
  };
}
