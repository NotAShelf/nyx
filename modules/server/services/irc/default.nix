{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    # https://nixos.wiki/wiki/Quassel
    services.quassel = {
      enable = true;
      portNumber = "4242";
      interfaces = ["0.0.0.0"];
      dataDir = "/home/${config.services.quassel.user}/quassel";
    };

    # pass quassel port to the firewall
    networking.firewall.allowedTCPPorts = ["${config.services.quassel.portNumber}"];

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql94;
    };

    # Only start Quassel after PostgreSQL has started
    systemd.services.quassel.after = ["postgresql.service"];

    # Make the quasselcore command available in the shell
    environment.systemPackages = [pkgs.quasselDaemon_qt5];
  };
}
