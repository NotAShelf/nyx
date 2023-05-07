{
  config,
  pkgs,
  osConfig,
  ...
}: let
  inherit (config.colorscheme) colors;

  pointer = config.home.pointerCursor;
  cfg = osConfig.modules.programs.default;
  monitors = osConfig.modules.device.monitors;

  fileManager = osConfig.modules.programs.default.fileManager;

  terminal =
    if (cfg.terminal == "foot")
    then "footclient"
    else "kitty";
in {
  wayland.windowManager.hyprland.extraConfig = ''
    # set cursor for HL itself
    exec-once = hyprctl setcursor ${pointer.name} ${toString pointer.size}
    exec-once = run-as-service 'foot --server'

    # monitor=eDP-1,preferred,0x0,1
    ${builtins.concatStringsSep "\n" (builtins.map (monitor: ''monitor=${monitor},preferred,0x0,1'') monitors)}


    input {
      kb_layout=tr
      kb_variant=
      kb_model=
      kb_options=
      kb_rules=

      follow_mouse=1

      touchpad {
        natural_scroll=no
      }
    }

    general {
      sensitivity=0.7 # for mouse cursor

      gaps_in=6
      gaps_out=11
      border_size=3
      col.active_border=0xff${colors.base0F}
      col.inactive_border=0x00${colors.base00}

      apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
    }

    misc {
      disable_hyprland_logo=true
      disable_splash_rendering=true
      enable_swallow=true
      swallow_regex=foot|thunar|nemo
      mouse_move_enables_dpms=true
      key_press_enables_dpms=true
      disable_autoreload=true # autoreload is unnecessary on nixos
    }

    decoration {
      rounding=5
      multisample_edges=true
      blur_new_optimizations=1
      blur=1
      blur_size=4
      blur_passes=3

      drop_shadow = yes
      shadow_range = 4
      shadow_render_power = 3
      col.shadow = rgba(292c3cee)
    }

    animations {
      enabled = true
      bezier = smoothOut, 0.36, 0, 0.66, -0.56
      bezier = smoothIn, 0.25, 1, 0.5, 1
      bezier = overshot,0.4,0.8,0.2,1.2

      animation = windows, 1, 4, overshot, slide
      animation = windowsOut, 1, 4, smoothOut, slide
      animation = border,1,10,default

      animation = fade, 1, 10, smoothIn
      animation = fadeDim, 1, 10, smoothIn
      animation = workspaces,1,4,overshot,slidevert

    }

    dwindle {
      pseudotile = false
      preserve_split = yes
      no_gaps_when_only = false
    }

    $MOD = SUPER

    $disable=act_opa=$(hyprctl getoption "decoration:active_opacity" -j | jq -r ".float");inact_opa=$(hyprctl getoption "decoration:inactive_opacity" -j | jq -r ".float");hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1"
    $enable=hyprctl --batch "keyword decoration:active_opacity $act_opa;keyword decoration:inactive_opacity $inact_opa"

    # logout menu
    bind = $MODSHIFT, Escape, exec, wlogout -p layer-shell
    # lock screen
    bind=$MODSHIFT,L,exec,swaylock


    bind=$MOD,F1,exec,firefox
    bind=$MOD,F2,exec,run-as-service "${fileManager}"
    bind=$MOD,RETURN,exec,run-as-service "${terminal}"
    bind=$MODSHIFT,Q,killactive,
    bind=$MODSHIFT,G,changegroupactive,
    bind=$MOD,T,togglegroup,
    bind=$MODSHIFT,E,exit,
    bind=$MOD,V,togglefloating,
    bind=$MOD,R,exec, killall tofi || run-as-service $(tofi-drun --prompt-text "  Run")
    bind=$MOD,D,exec, killall rofi || rofi -show drun
    bind=$MOD,equal,exec, killall rofi || rofi -show calc
    bind=$MOD,period,exec, killall rofi || rofi -show emoji
    bind=$MOD,P,pseudo,
    bind=$MOD,F,fullscreen,

    # workspace controls
    bind=$MODSHIFT,right,movetoworkspace,+1
    bind=$MODSHIFT,left,movetoworkspace,-1
    bind=$MOD,mouse_down,workspace,e+1
    bind=$MOD,mouse_up,workspace,e-1


    # hide Waybar
    bind=$MOD,B,exec,killall -SIGUSR1 waybar
    bind=$MODSHIFT,B,exec,killall -SIGUSR2 waybar; waybar&

    # move focus
    bind = $MOD, left, movefocus, l
    bind = $MOD, right, movefocus, r
    bind = $MOD, up, movefocus, u
    bind = $MOD, down, movefocus, d

    bindm=$MOD,mouse:272,movewindow
    bindm=$MOD,mouse:273,resizewindow

    # window resize
    bind = $MOD, S, submap, resize

    # brightness controls
    bind=,XF86MonBrightnessUp,exec,brightness set +5%
    bind=,XF86MonBrightnessDown,exec,brightness set 5%-
    # set brigtness to 90% on init because it gets reset thanks to btrfs rollback
    exec-once = brightness set 90%

    # media controls
    bindl=,XF86AudioPlay,exec,playerctl play-pause
    bindl=,XF86AudioPrev,exec,playerctl previous
    bindl=,XF86AudioNext,exec,playerctl next

    # volume
    binde=, XF86AudioRaiseVolume, exec, volume -i 5
    bindl=, XF86AudioLowerVolume, exec, volume -d 5
    bindl=, XF86AudioMute, exec, volume -t


    submap=resize
    binde=,right,resizeactive,10 0
    binde=,left,resizeactive,-10 0
    binde=,up,resizeactive,0 -10
    binde=,down,resizeactive,0 10
    bind=,escape,submap,reset
    submap=reset

    # select area to perform OCR on
    bind = $MODSHIFT,O,exec,run-as-service wl-ocr

    # screenshot
    # stop animations while screenshotting; makes black border go away

    bind=$MOD SHIFT,P,exec,$disable; grim - | wl-copy --type image/png && notify-send "Screenshot" "Screenshot copied to clipboard"; $enable
    bind=$MOD SHIFT,S,exec,$disable; hyprshot; $enable

    $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
    bind = , Print, exec, $screenshotarea
    bind = $MOD SHIFT, R, exec, $screenshotarea

    bind = $MOD, Print, exec, grimblast --notify --cursor copysave output
    bind = $MOD SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output

    bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
    bind = $MOD SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen

    windowrule=tile,title:Spotify
    windowrule=fullscreen,wlogout
    windowrule=float,title:wlogout
    windowrule=fullscreen,title:wlogout
    windowrule=float,pavucontrol-qt
    windowrule=float,Bitwarden
    windowrule=nofullscreenrequest,class:firefox
    windowrule=idleinhibit focus,mpv
    windowrule=idleinhibit focus,foot
    windowrule=idleinhibit fullscreen,firefox

    windowrule=float,udiskie
    windowrule=float,title:^(Volume Control)$
    windowrule=float,title:^(Firefox — Sharing Indicator)$
    windowrule=move 0 0,title:^(Firefox — Sharing Indicator)$

    windowrule=size 800 600,title:^(Volume Control)$
    windowrule=move 75 44%,title:^(Volume Control)$

    # telegram media viewer
    windowrulev2 = float, title:^(Media viewer)$

    # make Firefox PiP window floating and sticky
    windowrulev2 = float, title:^(Picture-in-Picture)$
    windowrulev2 = pin, title:^(Picture-in-Picture)$

    # throw sharing indicators away
    #windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$
    #windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$

    # start Discord/WebCord in ws2
    windowrulev2 = workspace 4, title:^(.*(Disc|WebC)ord.*)$

    # start spotify & steam tiled in ws3 and ws9
    windowrulev2 = tile, class:^(Spotify)$
    windowrulev2 = workspace 4 silent, class:^(Spotify)$

    # idle inhibit while watching videos
    windowrulev2 = idleinhibit focus, class:^(mpv)$
    windowrulev2 = idleinhibit fullscreen, class:^(firefox)$


    # workspace binds
    # binds mod + [shift +] {1..10} to [move to] ws {1..10}
    ${
      builtins.concatStringsSep "\n" (builtins.genList (
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
}
