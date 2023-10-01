{
  config,
  pkgs,
  osConfig,
  lib,
  defaults,
  ...
}: let
  inherit (lib) optionalString imap0;

  inherit (config.colorscheme) colors;
  inherit (import ./propaganda.nix pkgs) propaganda;

  pointer = config.home.pointerCursor;
  env = osConfig.modules.usrEnv;
  inherit (osConfig.modules.device) monitors;

  terminal =
    if (defaults.terminal == "foot")
    then "footclient"
    else "${defaults.terminal}";

  locker = lib.getExe pkgs.${env.screenLock};
in {
  wayland.windowManager.hyprland = {
    settings = {
      # define the mod key
      "$MOD" = "SUPER";

      exec-once = [
        # set cursor for HL itself
        "hyprctl setcursor ${pointer.name} ${toString pointer.size}"

        # start foot server
        # if the home-manager module advertises the server option as true, then don't write this line
        "${optionalString (defaults.fileManager == "foot" && !config.programs.foot.server.enable) ''run-as-service 'foot --server'"''}"

        # workaround for brightness being reset on root rollback (impermanence)
        "brightness set 90%"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      input = {
        # keyboard layout
        kb_layout = "tr";
        # self explanatory, I hope?
        follow_mouse = 1;
        # do not imitate natural scroll
        touchpad.natural_scroll = "no";
      };

      general = {
        # sensitivity of the mouse cursor
        sensitivity = 0.8;

        # gaps
        gaps_in = 6;
        gaps_out = 11;

        # border thiccness
        border_size = 3;

        # active border color
        "col.active_border" = "0xff${colors.base0F}";
        "col.group_border_active" = "rgba(88888888)";
        "col.group_border" = "rgba(00000088)";

        # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
        apply_sens_to_raw = 0;
      };

      decoration = {
        # fancy corners
        rounding = 7;

        # blur
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
          ignore_opacity = true;
          new_optimizations = 1;
          xray = true;
          contrast = 0.7;
          brightness = 0.8;
        };

        # shadow config
        drop_shadow = "yes";
        shadow_range = 20;
        shadow_render_power = 5;
        "col.shadow" = "rgba(292c3cee)";
      };

      misc = {
        # disable redundant renders
        disable_hyprland_logo = true; # wallpaper covers it anyway
        disable_splash_rendering = true; # "

        # window swallowing
        enable_swallow = true; # hide windows that spawn other windows
        swallow_regex = "foot|thunar|nemo"; # windows for which swallow is applied

        # dpms
        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action
        disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway

        # groupbar stuff
        # this removes the ugly gradient around grouped windows - which sucks
        groupbar_titles_font_size = 16;
        groupbar_gradients = false;
      };

      animations = {
        enabled = true; # we want animations, half the reason why we're on Hyprland innit

        bezier = [
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.4,0.8,0.2,1.2"
        ];

        animation = [
          "windows, 1, 4, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "border,1,10,default"

          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces,1,4,overshot,slidevert"
        ];
      };

      dwindle = {
        pseudotile = false;
        preserve_split = "yes";
        no_gaps_when_only = false;
      };

      # keyword to toggle "monocle" - a.k.a no_gaps_when_only
      "$kw" = "dwindle:no_gaps_when_only";
      "$disable" = ''act_opa=$(hyprctl getoption "decoration:active_opacity" -j | jq -r ".float");inact_opa=$(hyprctl getoption "decoration:inactive_opacity" -j | jq -r ".float");hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1"'';
      "$enable" = ''hyprctl --batch "keyword decoration:active_opacity $act_opa;keyword decoration:inactive_opacity $inact_opa"'';
      #"$screenshotarea" = ''hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"''

      bind = [
        # Misc
        "$MODSHIFT, Escape, exec, wlogout -p layer-shell" # logout menu
        "$MODSHIFT, L, exec, ${locker}" # lock the screen with swaylock
        "$MODSHIFT,E,exit," # exit Hyprland session
        ''$MODSHIFT,H,exec,cat ${propaganda} | wl-copy && notify-send "Propaganda" "ready to spread!" && sleep 0.3 && ${lib.getExe pkgs.wtype} -M ctrl -M shift -k v -m shift -m ctrl -s 300 -k Return'' # spread hyprland propaganda

        # Daily Applications
        "$MOD,F1,exec,firefox" # browser
        ''$MOD,F2,exec,run-as-service "${defaults.fileManager}"'' # file manager
        ''$MOD,RETURN,exec,run-as-service "${terminal}"'' # terminal
        ''$MODSHIFT,RETURN,exec,run-as-service "${terminal}"'' # floating terminal (TODO)
        ''$MOD,D,exec, killall rofi || run-as-service $(rofi -show drun)'' # application launcher
        "$MOD,equal,exec, killall rofi || rofi -show calc" # calc plugin for rofi
        "$MOD,period,exec, killall rofi || rofi -show emoji" # emoji plugin for rofi
        ''$MOD,R,exec, killall tofi || run-as-service $(tofi-drun --prompt-text "  Run")'' # alternative app launcher
        ''$MODSHIFT,R,exec, killall anyrun || run-as-service $(anyrun)'' # alternative application launcher with more features

        # window operators
        "$MODSHIFT,Q,killactive," # kill focused window
        "$MOD,T,togglegroup," # group focused window
        "$MODSHIFT,G,changegroupactive," # switch within the active group
        "$MOD,V,togglefloating," # toggle floating for the focused window
        "$MOD,P,pseudo," # pseudotile focused window
        "$MOD,F,fullscreen," # fullscreen focused window
        "$MOD,M,exec,hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))" # toggle no_gaps_when_only

        # workspace controls
        "$MODSHIFT,right,movetoworkspace,+1" # move focused window to the next ws
        "$MODSHIFT,left,movetoworkspace,-1" # move focused window to the previous ws
        "$MOD,mouse_down,workspace,e+1" # move to the next ws
        "$MOD,mouse_up,workspace,e-1" # move to the previous ws

        # focus controls
        "$MOD, left, movefocus, l" # move focus to the window on the left
        "$MOD, right, movefocus, r" # move focus to the window on the right
        "$MOD, up, movefocus, u" # move focus to the window above
        "$MOD, down, movefocus, d" # move focus to the window below

        # screenshot and receording binds
        ''$MODSHIFT,P,exec,$disable; grim - | wl-copy --type image/png && notify-send "Screenshot" "Screenshot copied to clipboard"; $enable''
        "$MODSHIFT,S,exec,$disable; hyprshot; $enable" # screenshot and then pipe it to swappy
        "$MOD, Print, exec, grimblast --notify --cursor copysave output" # copy all active outputs
        "$ALTSHIFT, S, exec, grimblast --notify --cursor copysave screen" # copy active screen
        "$ALTSHIFT, R, exec, grimblast --notify --cursor copysave area" # copy selection area

        # OCR
        "$MODSHIFT,O,exec,ocr"

        /*
        , Print, exec, $screenshotarea
        $ALTSHIFT, S, exec, $screenshotarea
        */
      ];

      bindm = [
        "$MOD,mouse:272,movewindow"
        "$MOD,mouse:273,resizewindow"
      ];
      # binds that will be repeated, a.k.a can be held to toggle multiple times
      binde = [
        # volume controls
        ",XF86AudioRaiseVolume, exec, volume -i 5"
        ",XF86AudioLowerVolume, exec, volume -d 5"
        ",XF86AudioMute, exec, volume -t"

        # brightness controls
        ",XF86MonBrightnessUp,exec,brightness set +5%"
        ",XF86MonBrightnessDown,exec,brightness set 5%-"
      ];

      # binds that are locked, a.k.a will activate even while an input inhibitor is active
      bindl = [
        # media controls
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPrev,exec,playerctl previous"
        ",XF86AudioNext,exec,playerctl next"
      ];

      windowrulev2 = [
        # only allow shadows for floating windows
        "noshadow, floating:0"
        "tile, title:Spotify"
        "fullscreen,class:wlogout"
        "fullscreen,title:wlogout"

        # telegram media viewer
        "float, title:^(Media viewer)$"

        "float,class:Bitwarden"
        "size 800 600,class:Bitwarden"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit focus,class:foot"

        "idleinhibit fullscreen, class:^(firefox)$"
        "float,title:^(Firefox — Sharing Indicator)$"
        "move 0 0,title:^(Firefox — Sharing Indicator)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "float,class:udiskie"

        # pavucontrol
        "float,class:pavucontrol"
        "float,title:^(Volume Control)$"
        "size 800 600,title:^(Volume Control)$"
        "move 75 44%,title:^(Volume Control)$"
        "float, class:^(imv)$"

        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        "workspace 4, title:^(.*(Disc|WebC)ord.*)$"
        "tile, class:^(Spotify)$"
        "workspace 3 silent, class:^(Spotify)$"

        "workspace 10 silent, class:^(Nextcloud)$"
      ];
    };

    extraConfig = let
      # divide workspaces between monitors
      mapMonitorsToWs = builtins.concatStringsSep "\n" (
        builtins.genList (
          x: ''
            workspace = ${toString (x + 1)}, monitor:${
              if (x + 1) <= 5
              then "${builtins.elemAt monitors 0} ${
                if (x + 1) == 1
                then ", default:true"
                else ""
              }"
              else "${builtins.elemAt monitors 1}"
            }

          ''
        )
        10
      );

      # generate monitor config strings
      mapMonitors = builtins.concatStringsSep "\n" (imap0 (i: monitor: ''monitor=${monitor},${
          if monitor == "DP-1"
          then "1920x1080@144"
          else "preferred"
        }, ${toString (i * 1920)}x0,1'')
      monitors);
    in ''
      # generate a list of monitors automatically, like so
      #monitor=HDMI-A-1,preferred,0x0,1
      # monitor=DP-1,preferred,1920x0,1
      ${mapMonitors}

      # if I have a second monitor, indicated by the element count of the monitors list, divide the workspaces
      # inbetween two workspaces -> 1-5 on mon1 and 6-10 on mon2
      # if not, then don't divide workspaces
      # P.S. I really don't know what I will do if I get a third monitor
      ${lib.optionalString (builtins.length monitors != 1) "${mapMonitorsToWs}"}

      # a submap for resizing windows
      bind = $MOD, S, submap, resize # enter resize window to resize the active window
      submap=resize
      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10
      bind=,escape,submap,reset
      submap=reset

      # workspace binds
      # binds * (asterisk) to special workspace
      bind = $MOD, KP_Multiply, togglespecialworkspace
      bind = $MODSHIFT, KP_Multiply, movetoworkspace, special

      # and mod + [shift +] {1..10} to [move to] ws {1..10}
      ${
        builtins.concatStringsSep "\n"
        (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in ''
              bind = $MOD, ${ws}, workspace, ${toString (x + 1)}
              bind = $MOD SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
            ''
          )
          10)
      }
    '';
  };
}
