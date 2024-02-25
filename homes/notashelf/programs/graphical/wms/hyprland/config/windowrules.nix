{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # only allow shadows for floating windows
      "noshadow, floating:0"
      "tile, title:Spotify"
      "fullscreen,class:wlogout"
      "fullscreen,title:wlogout"
      "noanim, title:wlogout"

      # telegram media viewer
      "float, title:^(Media viewer)$"

      # bitwarden
      "float,class:Bitwarden"
      "size 800 600,class:Bitwarden"

      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit focus,class:foot"

      # firefox
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

      # EA launcher puts a tiny window in the current workspae
      # throw it away
      "workspace special silent, title:^(title:Wine System Tray)$"

      "workspace 4, title:^(.*(Disc|WebC)ord.*)$"
      "tile, class:^(Spotify)$"
      "workspace 3 silent, class:^(Spotify)$"

      "workspace 10 silent, class:^(Nextcloud)$"
    ];
  };
}
