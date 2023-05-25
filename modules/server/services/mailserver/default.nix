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
    # required for roundcube
    networking.firewall.allowedTCPPorts = [80 443];

    services.roundcube = {
      enable = true;
      # this is the url of the vhost, not necessarily the same as the fqdn of
      # the mailserver
      hostName = "mail.notashelf.dev";
      extraConfig = ''
        # starttls needed for authentication, so the fqdn required to match
        # the certificate
        $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';
    };

    mailserver = {
      enable = true;
      openFirewall = true;
      #enableImap = false;
      #enableImapSsl = true;
      #enableSubmission = false;
      #enableSubmissionSsl = true;
      #certificateDomains = ["imap.notashelf.dev"];
      certificateScheme = "acme-nginx";
      domains = ["notashelf.dev"];
      loginAccounts = {
        "raf@notashelf.dev" = {
          hashedPasswordFile = config.age.secrets.mailserver-secret.path;
          aliases = ["admin@notashelf.dev" "root@notashelf.dev" "postmaster@notashelf.dev"];
        };
      };

      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        # this only applies to plain text attachments, binary attachments are never indexed
        indexAttachments = true;
        enforced = "body";
      };
    };
  };
}
