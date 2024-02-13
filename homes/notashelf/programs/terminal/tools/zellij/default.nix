{
  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false; # do NOT auto-start, thank you
      settings = {
        default_layout = "compact";
        default_mode = "locked";

        on_force_close = "quit";
        pane_frames = true;

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
