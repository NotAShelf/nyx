{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: super: {
      nginxStable = super.nginxStable.override {openssl = super.pkgs.libressl;};
    })
  ];

  services = {
    prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
      openFirewall = true;
      firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
    };
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "notashelf.dev" = {
          addSSL = true;
          serverAliases = ["www.notashelf.dev"];
          enableACME = true;
          root = "/srv/www/notashelf.dev";
        };

        "git.notashelf.dev" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:7000/";
          };
        };
      };
    };
    gitea = {
      enable = false;
      lfs.enable = true;

      user = "git";
      database.user = "git";

      appName = "The Secret Shelf";
      domain = "git.notashelf.dev";
      rootUrl = "https://git.notashelf.dev";
      httpPort = 7000;
      settings = {
        repository.PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";
        server = {
          START_SSH_SERVER = false;
          BUILTIN_SSH_SERVER_USER = "git";
          SSH_PORT = 22;
          DISABLE_ROUTER_LOG = true;
          SSH_CREATE_AUTHORIZED_KEYS_FILE = false;
        };
        attachment.ALLOWED_TYPES = "*/*";
        service.DISABLE_REGISTRATION = true;
        ui.DEFAULT_THEME = "arc-green";
      };
    };
  };
}
