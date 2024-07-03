{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.thunderbird.enable {
    home.packages = with pkgs; [birdtray thunderbird];

    programs.thunderbird = {
      enable = true;
      profiles."notashelf" = {
        isDefault = true;
        userChrome = "";
        userContent = "";
        withExternalGnupg = true;
      };
    };

    /*
    systemd.user.services = {
      "birdtray" = {
        Install.WantedBy = ["graphical-session.target"];

        Service = {
          ExecStart = "${getExe' pkgs.birdtray "birdtray"}";
          Restart = "always";
          # runtime
          RuntimeDirectory = "ags";
          ProtectSystem = "strict";
          ProtectHome = "read-only";
        };

        Unit = {
          Description = "mail system tray notification icon for Thunderbird ";
          After = ["graphical-session-pre.target"];
          PartOf = [
            "tray.target"
            "graphical-session.target"
          ];
        };
      };
    };
    */
  };
}
