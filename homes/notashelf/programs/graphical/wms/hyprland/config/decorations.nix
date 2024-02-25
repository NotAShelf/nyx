{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      # fancy corners
      rounding = 7;

      # blur
      blur = {
        enabled = true;
        size = 5;
        passes = 3;
        ignore_opacity = true;
        new_optimizations = 1;
        xray = true;
        contrast = 0.7;
        brightness = 0.8;
        vibrancy = 0.2;
        special = true; # expensive, but helps distinguish special workspaces
      };

      # shadow config
      drop_shadow = "yes";
      shadow_range = 10;
      shadow_render_power = 3;
      "col.shadow" = "rgba(292c3cee)";
    };

    group = {
      # new windows in a group spawn after current or at group tail
      insert_after_current = true;
      # focus on the window that has just been moved out of the group
      focus_removed_window = true;

      "col.border_active" = "rgba(88888888)";
      "col.border_inactive" = "rgba(00000088)";

      groupbar = {
        # groupbar stuff
        # this removes the ugly gradient around grouped windows - which sucks
        gradients = false;
        font_size = 14;

        # titles look ugly, and I usually know what I'm looking at
        render_titles = false;

        # scrolling in the groupbar changes group active window
        scrolling = true;
      };
    };

    animations = {
      enabled = true; # we want animations, half the reason why we're on Hyprland innit
      first_launch_animation = true; # fade in on first launch

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
  };
}
