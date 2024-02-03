{colors}:
with colors; ''
  local wezterm = require("wezterm")
  local act = wezterm.action

  return {
  	check_for_updates = false,
  	exit_behavior = "CloseOnCleanExit",

    enable_scroll_bar = true,

  	font_size = 14.0,
  	font = wezterm.font 'Iosevka Nerd Font Mono'

  	audible_bell = "Disabled",
    enable_tab_bar = true,
  	hide_tab_bar_if_only_one_tab = true,
  	default_cursor_style = "SteadyUnderline",
  	window_background_opacity = 0.85,

  	window_padding = {
  		left = 16,
  		right = 16,
  		top = 16,
  		bottom = 16,
  	},

  	colors = {
      background = "#${base00}",
      cursor_bg = "#${base05}",
      cursor_fg = "#${base00}",
      cursor_border = "#${base05}",
      foreground = "#${base05}",
      selection_bg = "#${base05}",
      selection_fg = "#${base00}",

      tab_bar = {
    	  background = "#${base02}",
    	  active_tab = {
    		  bg_color = "#${base0D}",
    		  fg_color = "#${base00}",
    	  },

        inactive_tab = {
    		  bg_color = "#${base00}",
    		  fg_color = "#${base08}",
    	  },

        inactive_tab_hover = {
    		  bg_color = "#${base00}",
    		  fg_color = "#${base0D}",
    	  },

        new_tab = {
    		  bg_color = "#${base02}",
    		  fg_color = "#${base08}",
    	  },

        new_tab_hover = {
    		  bg_color = "#${base00}",
    		  fg_color = "#${base0D}",
    	  },
      },


      ansi = {
        "#${base00}",
        "#${base08}",
        "#${base0B}",
        "#${base0A}",
        "#${base0D}",
        "#${base0F}",
        "#${base0C}",
        "#${base05}"
      },

      brights = {
        "#${base03}",
        "#${base08}",
        "#${base0B}",
        "#${base0A}",
        "#${base0D}",
        "#${base0F}",
        "#${base0C}",
        "#${base07}"
      },
    },
  }
''
