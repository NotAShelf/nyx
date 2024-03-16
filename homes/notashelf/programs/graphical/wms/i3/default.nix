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
              block = "custom";
              command = "${pkgs.rsstail}/bin/rsstail rsstail -n 1 -1 -N -u https://github.com/nixos/nixpkgs/commits/master.atom";
              interval = 60;
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              format_alt = " $icon $swap_used_percents ";
            }
            {
              block = "cpu";
              interval = 1;
              format = " $barchart $utilization $frequency ";
            }
            {
              block = "sound";
            }
            {
              block = "battery";
              device = "BAT1";
              format = " $icon $percentage $time $power ";
            }
            {
              block = "net";
              format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
              interval = 2;
            }
            {
              block = "time";
              interval = 1;
              format = " $timestamp.datetime(f:'%F %T') ";
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
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs --config ~/.config/i3status-rust/config-bottom.toml";
          }
        ];

        workspaceLayout = "tabbed";

        # keybindings
        keybindings = lib.mkOptionDefault {
          "${mod}+r" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          "${mod}+t" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+p" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

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

          # workspace selection
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 0";

          # keybindings for moving windows to different workspaces
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";

          # reload/restart/exit i3
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+e" = "restart";
          "${mod}+Shift+q" = "exit";

          # Move the currently focused window to scratchpad
          "${mod}+Shift+BackSpace" = "move scratchpad";

          # Show the first scratchpad window
          "${mod}+BackSpace" = "scratchpad show, move position center";
        };
      };
    };
  };
}
