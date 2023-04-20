{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
  port = 4242;
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    # https://nixos.wiki/wiki/Quassel
    services.quassel = {
      enable = true;
      portNumber = port;
      interfaces = ["0.0.0.0"];
      dataDir = "/home/${config.services.quassel.user}/quassel";
    };

    # pass quassel port to the firewall
    networking.firewall.allowedTCPPorts = [port];

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
    };

    # Only start Quassel after PostgreSQL has started
    systemd.services.quassel.after = ["postgresql.service"];

    # Make the quasselcore command available in the shell
    environment.systemPackages = [pkgs.quasselDaemon_qt5];
  };
}
