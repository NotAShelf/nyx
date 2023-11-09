{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system.networking = {
    optimizeTcp = mkEnableOption "TCP optimizations";

    tailscale = {
      client.enable = mkEnableOption "Tailscale for inter-machine VPN.";
      server.enable = mkEnableOption ''
        Tailscale inter-machine VPN exit node.

        This option is mutually exlusive with {option}`tailscale.client.enable` as they both
        configure Taiscale, but with different flags
      '';
    };

    # TODO: optionally use encrypted DNS
    # encryptDns = mkOption {};
  };
}
