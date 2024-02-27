{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
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

    systemd.user.services = {
      "birdtray" = {
        Install.WantedBy = ["graphical-session.target"];

        Service = {
          ExecStart = "${lib.getExe pkgs.birdtray}";
          Restart = "always";
        };

        Unit = {
          Description = "mail system tray notification icon for Thunderbird ";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
      };
    };
  };
}
