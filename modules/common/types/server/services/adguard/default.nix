{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.services.adguard.enable {
    services.adguardhome = {
      enable = true;
      allowDHCP = true;
      settings = {
        bind_host = "0.0.0.0";
        bind_port = 3500;
      };
    };

    networking.firewall.allowedTCPPorts = [
      3500
    ];

    networking.firewall.allowedUDPPorts = [];

    services.caddy = {
      enable = true;

      virtualHosts.${config.services.adguard.host}.extraConfig = ''
        reverse_proxy 127.0.0.1:3500
      '';
    };
  };
}
