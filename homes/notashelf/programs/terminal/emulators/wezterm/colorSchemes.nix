{colors}:
with colors; {
  followSystem = {
    # basic colors
    background = "#${base00}";
    foreground = "#${base05}";

    cursor_border = "#${base05}";
    cursor_bg = "#${base05}";
    cursor_fg = "#${base08}";

    selection_bg = "#${base0E}";
    selection_fg = "#${base00}";

    split = "#${base01}";

    # base16
    ansi = [
      "#${base03}"
      "#${base08}"
      "#${base0B}"
      "#${base0A}"
      "#${base0D}"
      "#${base0F}"
      "#${base0C}"
      "#${base06}"
    ];

    brights = [
      "#${base04}"
      "#${base08}"
      "#${base0B}"
      "#${base0A}"
      "#${base0D}"
      "#${base0F}"
      "#${base0C}"
      "#${base07}"
    ];

    # tabbar
    tab_bar = {
      background = "#${base08}";
      active_tab = {
        bg_color = "#${base00}";
        fg_color = "#${base05}";
      };

      inactive_tab = {
        bg_color = "#${base08}";
        fg_color = "#${base05}";
      };

      inactive_tab_hover = {
        bg_color = "#${base00}";
        fg_color = "#${base05}";
      };

      inactive_tab_edge = "#${base00}";

      new_tab = {
        bg_color = "#${base08}";
        fg_color = "#${base07}";
      };

      new_tab_hover = {
        bg_color = "#${base00}";
        fg_color = "#${base05}";
      };
    };
  };
}
