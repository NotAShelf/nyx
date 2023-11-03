{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.services.tailscale) interfaceName port;

  sys = config.modules.system;
in {
  # TODO: add the tailscale-server module to the system module
  # and separate the client module so that they do not conflict
  config = lib.mkIf sys.networking.tailscale-server.enable {
    environment.systemPackages = with pkgs; [tailscale];

    networking.firewall = {
      trustedInterfaces = [interfaceName];
      allowedUDPPorts = [port];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "server";
      extraUpFlags = [
        "--advertise-exit-node"
        "--ssh"
      ];
    };
  };
}
