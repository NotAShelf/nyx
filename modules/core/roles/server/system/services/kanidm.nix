{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  domain = "idm.notashelf.dev";
  certDir = config.security.acme.certs.${domain}.directory;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.kanidm.enable {
    services.kanidm = {
      enableServer = true;
      serverSettings = {
        inherit domain;
        origin = "https://${domain}";
        bindaddress = "127.0.0.1:8443";
        trust_x_forward_for = true;
        #tls_chain = "${certDir}/fullchain.pem";
        #tls_key = "${certDir}/key.pem";
        online_backup = {
          path = "/srv/storage/kanidm/backups";
          schedule = "0 0 * * *"; # Every day at midnight.
        };
      };
    };

    systemd.services.kanidm = {
      after = ["acme-selfsigned-internal.${domain}.target"];
      serviceConfig = {
        SupplementaryGroups = [config.security.acme.certs.${domain}.group];
        BindReadOnlyPaths = [certDir];
      };
    };

    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "https://${config.services.kanidm.serverSettings.bindaddress}";
    };
  };
}
