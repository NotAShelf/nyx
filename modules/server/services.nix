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

  systemd.services.gitea.serviceConfig.SystemCallFilter =
    lib.mkForce
    "~@clock @cpu-emulation @debug @keyring @memlock @module @obsolete @raw-io @reboot @resources @setuid @swap";

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
        #"notashelf.dev" = {
        #  addSSL = true;
        #  serverAliases = ["www.notashelf.dev"];
        #  enableACME = true;
        #  root = "/srv/www/notashelf.dev";
        #};

        #"git.notashelf.dev" = {
        #  addSSL = true;
        #  enableACME = true;
        #  locations."/" = {
        #    proxyPass = "http://localhost:7000/";
        #  };
        #};
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

    # services.tor.relay.onionServices = {
    #   # hide ssh from script kiddies
    #   ssh = {
    #     version = 3;
    #     map = [{port = 22;}];
    #   };
    #   # feds crying rn
    #   website = {
    #     version = 3;
    #     map = [{port = 80;}];
    #   };
    # };

    tor.settings = {
      DnsPort = 9053;
      AutomapHostsOnResolve = true;
      AutomapHostsSuffixes = [".exit" ".onion"];
      EnforceDistinctSubnets = true;
      ExitNodes = "{pl}";
      EntryNodes = "{pl}";
      NewCircuitPeriod = 120;
      DNSPort = 9053;
    };
  };
}
