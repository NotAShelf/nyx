{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
}
