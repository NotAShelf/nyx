{
  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false; # do NOT auto-start, thank you
      settings = {
        # custom defined layouts
        layout_dir = "${./layouts}";

        auto_layouts = true;

        default_layout = "system"; # or compact
        default_mode = "locked";

        on_force_close = "quit";
        pane_frames = true;
        session_serialization = false;

        ui.pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };

        plugins = {
          tab-bar.path = "tab-bar";
          status-bar.path = "status-bar";
          strider.path = "strider";
          compact-bar.path = "compact-bar";
        };
      };
    };
  };
}
