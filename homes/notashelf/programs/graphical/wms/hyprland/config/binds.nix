{
  inputs',
  osConfig,
  defaults,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  # nix advantages
  inherit (import ../packages {inherit inputs' pkgs;}) propaganda;

  terminal =
    if (defaults.terminal == "foot")
    then "footclient"
    else "${defaults.terminal}";

  locker = getExe env.programs.screenlock.package;
in {
  wayland.windowManager.hyprland.settings = {
    # define the mod key
    "$MOD" = "SUPER";

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
      ''$MODSHIFT,H,exec,cat ${propaganda} | ${pkgs.wl-clipboard}/bin/wl-copy && ${pkgs.libnotify}/bin/notify-send "Propaganda" "ready to spread!" && sleep 0.3 && ${lib.getExe pkgs.wtype} -M ctrl -M shift -k v -m shift -m ctrl -s 300 -k Return'' # spread hyprland propaganda

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

      # Toggle Statusbar
      "$MODSHIFT,B,exec, ags -t bar"

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
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      # brightness controls
      '',XF86MonBrightnessUp,exec,ags --run-js "brightness.screen += 0.05"''
      '',XF86MonBrightnessDown,exec, ags --run-js "brightness.screen -= 0.05"''
    ];

    # binds that are locked, a.k.a will activate even while an input inhibitor is active
    bindl = [
      # media controls
      ",XF86AudioPlay,exec,playerctl play-pause"
      ",XF86AudioPrev,exec,playerctl previous"
      ",XF86AudioNext,exec,playerctl next"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];
  };
}
