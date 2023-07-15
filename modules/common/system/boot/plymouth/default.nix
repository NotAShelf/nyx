{
  config,
  lib,
  pkgs,
  self',
  ...
}: let
  inherit (pkgs) plymouth;
  inherit (lib) mkIf;

  cfg = config.modules.system.boot.plymouth;
in {
  config = mkIf cfg.enable {
    # configure plymouth theme
    # <https://github.com/adi1090x/plymouth-themes>
    boot.plymouth = let
      pack = cfg.pack;
      theme = cfg.theme;
    in
      {
        enable = true;
      }
      // lib.optionalAttrs cfg.withThemes {
        themePackages = [(self'.packages.plymouth-themes.override {inherit pack theme;})];

        inherit theme;
      };

    # make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };
  };
}
