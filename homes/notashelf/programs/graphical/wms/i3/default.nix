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
        top = {
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
              theme_overrides = {
                idle_bg = "#00223f";
              };
            }
            {
              block = "cpu";
              interval = 1;
              format = " $barchart $utilization $frequency ";
            }
            {
              block = "sound";
              theme_overrides = {
                idle_bg = "#00223f";
              };
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
              theme_overrides = {
                idle_bg = "#00223f";
              };
            }
            {
              block = "time";
              interval = 1;
              format = " $timestamp.datetime(f:'%F %T') ";
            }
          ];
          theme = "space-villain";
          icons = "none";
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
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
          }
        ];
        # keybindings
        keybindings = lib.mkOptionDefault {
          "${mod}+r" = "exec ${pkgs.dmenu}/bin/dmenu_run";
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
