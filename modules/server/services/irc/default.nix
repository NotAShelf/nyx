{
  pkgs,
  lib,
  config,
  ...
}: {
  # https://nixos.wiki/wiki/Quassel
  services.quassel = {
    enable = true;
    interfaces = ["0.0.0.0"];
  };

  networking.firewall.allowedTCPPorts = [4242];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql94;
  };

  /*
  Only start Quassel after PostgreSQL has started
  */
  systemd.services.quassel.after = ["postgresql.service"];

  /*
  Make the quasselcore command available in the shell
  */
  environment.systemPackages = [pkgs.quasselDaemon_qt5];
}
