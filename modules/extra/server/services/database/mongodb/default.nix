{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.services.override;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.database.mongodb)) {
    services.mongodb = {
      enable = true;
      package = pkgs.mongodb;
      enableAuth = true;
      initialRootPassword = config.age.secrets.mongodb-secret.path;
      #bind_ip = "0.0.0.0";
      extraConfig = ''
        operationProfiling.mode: all
      '';
    };
  };
}
