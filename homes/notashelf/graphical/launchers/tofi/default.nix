{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  sys = osConfig.modules.system;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes && sys.video.enable) {
    home.packages = with pkgs; let
      emoji = pkgs.writeShellScriptBin "emoji" ''
        #!/bin/sh
        chosen=$(cut -d ';' -f1 ${./emoji} | tofi | sed "s/ .*//")
        [ -z "$chosen" ] && exit
        if [ -n "$1" ]; then
        	wtype "$chosen"
        else
        	printf "$chosen" | wl-copy
        	notify-send "'$chosen' copied to clipboard." &
        fi
      '';
    in [
      # for compatibility sake
      (writeScriptBin "dmenu" ''exec ${lib.getExe tofi}'')
      tofi
      emoji
      wtype
    ];

    xdg.configFile."tofi/config".text = let
      inherit (config.colorscheme) colors;
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
