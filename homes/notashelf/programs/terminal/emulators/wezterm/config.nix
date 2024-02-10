{colors, ...}:
/*
lua
*/
''
  local wezterm = require("wezterm")
  local act = wezterm.action

  -- wezterm.gui is not available to the mux server, so take care to
  -- do something reasonable when this config is evaluated by the mux
  function get_appearance()
    if wezterm.gui then
      return wezterm.gui.get_appearance()
    end
    return 'Dark'
  end

  function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
      return 'Catppuccin Mocha'
    else
      return 'Catppuccin Latte'
    end
  end

  return {
  	check_for_updates = false,
  	exit_behavior = "CloseOnCleanExit",

    enable_scroll_bar = false,

  	font_size = 14.0,
  	font = wezterm.font 'Iosevka Nerd Font',

    color_scheme = scheme_for_appearance(get_appearance()),

  	audible_bell = "Disabled",
    enable_tab_bar = true,
  	hide_tab_bar_if_only_one_tab = true,
  	default_cursor_style = "SteadyBar",
  	window_background_opacity = 0.85,

  	window_padding = {
  		left = 16,
  		right = 16,
  		top = 16,
  		bottom = 16,
  	},
  }
''
