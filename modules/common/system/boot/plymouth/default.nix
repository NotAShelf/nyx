{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) plymouth;

  cfg = config.modules.system.boot.plymouth;
in {
  # configure plymouth theme
  # <https://github.com/adi1090x/plymouth-themes>
  boot.plymouth = let
    pack = cfg.pack;
    theme = cfg.theme;
  in {
    enable = true;
    themePackages = [(pkgs.nixos-plymouth.override {inherit pack theme;})];
    # inherit theme;
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
}
