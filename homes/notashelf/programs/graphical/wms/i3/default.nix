{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
in {
  config = mkIf env.desktops.i3.enable {
    home.packages = [pkgs.maim];

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

    # use i3 as the window manager
    xsession.windowManager.i3 = let
      mod = "Mod4";
    in {
      enable = true;
      config = {
        # status bar configuration
        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          }
        ];
        # keybindings
        keybindings = lib.mkOptionDefault {
          "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          "${mod}+p" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          "${mod}+Shift+l" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

          # Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
        };
      };
    };
  };
}
