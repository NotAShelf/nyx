{osConfig, ...}: let
  inherit (osConfig.modules.style.colorScheme) slug colors;
in {
  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false; # do NOT auto-start, thank you
      settings = {
        # custom defined layouts
        layout_dir = "${./layouts}";

        # clipboard provider
        copy_command = "wl-copy";

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

        # load internal plugins from built-in paths
        plugins = {
          tab-bar.path = "tab-bar";
          status-bar.path = "status-bar";
          strider.path = "strider";
          compact-bar.path = "compact-bar";
        };

        # generate a local colorscheme from the system theming module
        # using the color palette and the slug provided by the module
        # this will ensure consistency, generally, with differing
        # colorschemes
        themes = {
          "${slug}" = with colors; {
            bg = "#${base00}";
            fg = "#${base05}";
            red = "#${base08}";
            green = "#${base0A}";
            blue = "#${base0D}";
            yellow = "#${base06}";
            magenta = "#${base0E}";
            orange = "#${base09}";
            cyan = "#${base0C}";
            black = "#${base00}";
            white = "#${base05}";
          };
        };

        # set theme to Catppuccin Mocha
        theme = "${slug}";
      };
    };
  };
}
