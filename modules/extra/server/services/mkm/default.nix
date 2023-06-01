{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
in {
  systemd.services = mkIf (config.networking.hostName == "helios") {
    mkm-web = {
      requires = ["mysql.service"];
      after = ["mysql.service"];
      description = "Mkm Ticketing";
      script = let
        pnpm = "${getExe pkgs.nodePackages_latest.pnpm}";
      in ''
        cd /home/notashelf/Dev/mkm-ticketing-main &&
        ${pnpm} install && ${pnpm} run start
      '';
    };
  };
}
