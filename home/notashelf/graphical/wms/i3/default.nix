{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
  device = osConfig.modules.device;
  sys = osConfig.modules.system;
in {
  config = mkIf ((sys.video.enable) && (env.isWayland == false && env.desktop == "i3")) {
    home.packages = with pkgs; [
      maim
    ];

    # use i3 as the window manager
    xsession.windowManager.i3 = let
      mod = "Mod4";
    in {
      enable = true;
      config = {
        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          }
        ];
      };

      /*
      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

        # Focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        # Move
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
      };
      */
    };
    # enable i3status for the bar
    programs.i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          blocks = [
            {
              block = "time";
              interval = 60;
              format = "%a %d/%m %k:%M %p";
            }
          ];
        };
      };
    };
  };
}
