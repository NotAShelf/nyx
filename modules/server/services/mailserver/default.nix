{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  device = config.modules.device;
  cfg = config.modules.programs.override;
  acceptedTypes = ["server" "hybrid"];
in {
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];

  config = mkIf (builtins.elem device.type acceptedTypes) {
    mailserver = {
      enable = true;
      openFirewall = true;
      enableImap = false;
      enableImapSsl = true;
      enableSubmission = false;
      enableSubmissionSsl = true;
      certificateDomains = ["imap.notashelf.dev"];
      fqdn = "mail.notashelf.dev";
      domains = ["notashelf.dev"];
      loginAccounts = {
        "raf@notashelf.dev" = {
          hashedPasswordFile = config.age.secrets.mailserver-secret.path;
          aliases = ["admin@notashelf.dev" "root@notashelf.dev"];
        };
      };
      certificateScheme = 2;
    };
  };
}
