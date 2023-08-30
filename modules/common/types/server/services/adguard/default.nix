{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.adguard.enable {
    services.adguardhome = {
      enable = true;
      allowDHCP = true;
    };

    networking.firewall.allowedTCPPorts = [
      53
      80
      3000
    ];

    networking.firewall.allowedUDPPorts = [
      53
      68
      67
      547
      546
    ];

    services.caddy = {
      enable = true;

      virtualHosts.${config.services.adguard.host}.extraConfig = ''
        reverse_proxy 127.0.0.1:3000
      '';
    };
  };
}
