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
    services.vaultwarden = {
      enable = true;
      backupDir = "/srv/storage/vaultwarden/backup";
      config = {
        DOMAIN = "https://vault.notashelf.dev";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        extendedLogging = true;
        invitationsAllowed = false;
        useSyslog = true;
        logLevel = "warn";
        showPasswordHint = false;
        signupsAllowed = false;
        signupsDomainsWhitelist = "notashelf.dev";
        signupsVerify = true;
        smtpAuthMechanism = "Login";
        smtpFrom = "vaultwarden@notashelf.dev";
        smtpFromName = "Vaultwarden";
        smtpHost = "mail.notashelf.dev";
        smtpPort = 587;
        smtpSecurity = "starttls";
        websocketAddress = "127.0.0.1";
        dataDir = "/srv/storage/bitwarden_rs";
      };
    };
  };
}
