{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.services.override;
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!cfg.vaultwarden)) {
    services = {
      vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://vault.notashelf.dev";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
        };
        backupDir = "/opt/vault";
      };
    };
  };
}
