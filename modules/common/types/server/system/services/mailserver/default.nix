{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  cfg = config.modules.services;
  acceptedTypes = ["server" "hybrid"];
in {
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];

  config = mkIf ((builtins.elem dev.type acceptedTypes) && cfg.mailserver.enable) {
    # required for roundcube
    networking.firewall.allowedTCPPorts = [80 443];

    services = {
      roundcube = {
        enable = true;
        database.username = "roundcube";
        maxAttachmentSize = 50;
        dicts = with pkgs.aspellDicts; [en tr de];
        # this is the url of the vhost, not necessarily the same as the fqdn of
        # the mailserver
        hostName = "webmail.notashelf.dev";
        extraConfig = ''
          $config['imap_host'] = array(
            'tls://mail.notashelf.dev' => "NotAShelf's Mail Server",
            'ssl://imap.gmail.com:993' => 'Google Mail',
          );
          $config['username_domain'] = array(
            'mail.notashelf.dev' => 'notashelf.dev',
            'mail.gmail.com' => 'gmail.com',
          );
          $config['x_frame_options'] = false;
          # starttls needed for authentication, so the fqdn required to match
          # the certificate
          $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
          $config['smtp_user'] = "%u";
          $config['smtp_pass'] = "%p";
          $config['plugins'] = [ "carddav" ];
        '';
      };

      postfix = {
        dnsBlacklists = [
          "all.s5h.net"
          "b.barracudacentral.org"
          "bl.spamcop.net"
          "blacklist.woody.ch"
        ];
        dnsBlacklistOverrides = ''
          notashelf.dev OK
          mail.notashelf.dev OK
          127.0.0.0/8 OK
          192.168.0.0/16 OK
        '';
        headerChecks = [
          {
            action = "IGNORE";
            pattern = "/^User-Agent.*Roundcube Webmail/";
          }
        ];

        config = {
          smtp_helo_name = config.mailserver.fqdn;
        };
      };

      phpfpm.pools.roundcube.settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
      };
    };

    mailserver = {
      enable = true;
      mailDirectory = "/srv/storage/mail/vmail";
      dkimKeyDirectory = "/srv/storage/mail/dkim";
      sieveDirectory = "/srv/storage/mail/sieve";
      openFirewall = true;
      enableImap = true;
      enableImapSsl = true;
      enablePop3 = false;
      enablePop3Ssl = false;
      enableSubmission = false;
      enableSubmissionSsl = true;
      hierarchySeparator = "/";
      localDnsResolver = false;
      fqdn = "mail.notashelf.dev";
      certificateScheme = "acme-nginx";
      domains = ["notashelf.dev"];
      loginAccounts = {
        "raf@notashelf.dev" = {
          hashedPasswordFile = config.age.secrets.mailserver-secret.path;
          aliases = [
            "me"
            "raf"
            "me@notashelf.dev"
            "admin"
            "admin@notashelf.dev"
            "root"
            "root@notashelf.dev"
            "postmaster"
            "postmaster@notashelf.dev"
          ];
        };

        "git@notashelf.dev" = {
          aliases = ["git"];
          hashedPasswordFile = config.age.secrets.mailserver-forgejo-secret.path;
        };

        "vaultwarden@notashelf.dev" = {
          aliases = ["vaultwarden"];
          hashedPasswordFile = config.age.secrets.mailserver-vaultwarden-secret.path;
        };

        "matrix@notashelf.dev" = {
          aliases = ["matrix"];
          hashedPasswordFile = config.age.secrets.mailserver-matrix-secret.path;
        };

        "cloud@notashelf.dev" = {
          aliases = ["cloud"];
          hashedPasswordFile = config.age.secrets.mailserver-cloud-secret.path;
        };

        "noreply@notashelf.dev" = {
          aliases = ["noreply"];
          hashedPasswordFile = config.age.secrets.mailserver-noreply-secret.path;
        };
      };

      mailboxes = {
        Archive = {
          auto = "subscribe";
          specialUse = "Archive";
        };
        Drafts = {
          auto = "subscribe";
          specialUse = "Drafts";
        };
        Sent = {
          auto = "subscribe";
          specialUse = "Sent";
        };
        Junk = {
          auto = "subscribe";
          specialUse = "Junk";
        };
        Trash = {
          auto = "subscribe";
          specialUse = "Trash";
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
