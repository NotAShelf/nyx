{lib, ...}: let
  inherit (lib) mkEnableOption mdDoc;
in {
  options.modules.system.networking = {
    optimizeTcp = mkEnableOption (mdDoc "Enable tcp optimizations");
    useTailscale = mkEnableOption (mdDoc "Use Tailscale for inter-machine VPN.");

    # TODO: optionally use encrypted DNS
    # encryptDns = mkOption {};
  };
}
