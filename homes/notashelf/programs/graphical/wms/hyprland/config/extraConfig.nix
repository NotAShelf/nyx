{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) imap0;
  inherit (osConfig) modules;
  inherit (modules.device) monitors;
in {
  wayland.windowManager.hyprland.extraConfig = let
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
}
