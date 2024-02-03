{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (osConfig) modules;

  env = modules.usrEnv;
in {
  config = mkIf env.launchers.tofi.enable {
    home.packages = with pkgs; [
      # for compatibility sake
      (pkgs.writeScriptBin "dmenu" ''exec ${getExe tofi}'')
      tofi
      wtype
    ];

    xdg.configFile."tofi/config".text = let
      inherit (osConfig.modules.style.colorScheme) colors;
    in ''
      font = Iosevka Nerd Font
      font-size = 13
      horizontal = true
      anchor = top
      width = 100%
      height = 40
      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 30
      padding-top = 10
      padding-bottom = 10
      padding-left = 20
      padding-right = 0
      margin-top = 0
      margin-bottom = 0
      margin-left = 15
      margin-right = 0
      prompt-text = " "
      prompt-padding = 30
      background-color = ${colors.base00}
      text-color = ${colors.base05}
      prompt-color = ${colors.base00}
      prompt-background = ${colors.base0D}
      prompt-background-padding = 4, 10
      prompt-background-corner-radius = 12
      input-background = ${colors.base02}
      input-background-padding = 4, 10
      input-background-corner-radius = 12
      selection-color = ${colors.base01}
      selection-background = ${colors.base0D}
      selection-background-padding = 4, 10
      selection-background-corner-radius = 12
      selection-match-color = ${colors.base05}
      clip-to-padding = false
    '';
  };
}
