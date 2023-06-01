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
      description = "Mkm Ticketing Frontend";
      requires = ["mysql.service"];
      after = ["network.target"];
      reloadIfChanged = true;
      serviceConfig = {
        ExecStart = "nix-shell --packages pnpm --run 'pnpm run build && pnpm start'";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
