{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && (env.programs.defaults.screenlocker == "swaylock") && (lib.isWayland osConfig)) {
    programs.swaylock = let
      inherit (config.colorscheme) colors;
    in {
      enable = true;
      package = with pkgs; swaylock-effects;
      settings = {
        clock = true;
        color = "${colors.base00}";
        font = "Work Sans";
        show-failed-attempts = false;
        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 20;
        line-color = "${colors.base00}";
        ring-color = "${colors.base04}";
        inside-color = "${colors.base00}";
        key-hl-color = "${colors.base0F}";
        separator-color = "00000000";
        text-color = "${colors.base05}";
        text-caps-lock-color = "";
        line-ver-color = "${colors.base0F}";
        ring-ver-color = "${colors.base0F}";
        inside-ver-color = "${colors.base00}";
        text-ver-color = "${colors.base05}";
        ring-wrong-color = "${colors.base08}";
        text-wrong-color = "${colors.base08}";
        inside-wrong-color = "${colors.base00}";
        inside-clear-color = "${colors.base00}";
        text-clear-color = "${colors.base05}";
        ring-clear-color = "${colors.base0B}";
        line-clear-color = "${colors.base00}";
        line-wrong-color = "${colors.base00}";
        bs-hl-color = "${colors.base08}";
        line-uses-ring = false;
        grace = 3;
        grace-no-mouse = true;
        grace-no-touch = true;
        datestr = "%d/%m/%Y";
        fade-in = "0.1";
        ignore-empty-password = true;
      };
    };
  };
}
