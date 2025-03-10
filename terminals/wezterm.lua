local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = { os.getenv("shell") }
config.initial_rows = 35
config.initial_cols = 172
config.max_fps = 120

config.font = wezterm.font('CaskaydiaCove Nerd Font', { weight = 'Regular' })

config.line_height = 1.35
-- config.freetype_load_target = 'Light'
config.font_size = 14
config.colors = {
  foreground = '#ffffff',
  background = '#15161b',
  cursor_bg = '#ffdb29',
  cursor_fg = '#15161b',
  selection_bg = '#3d424d',
  split = '#5C6773',
  ansi = {
    '#000000',
    '#ff5555',
    '#95FB79',
    '#FFEE99',
    '#82aaff',
    '#D2A6FF',
    '#82aaff',
    '#ffffff',
  },
  brights = {
    '#656565',
    '#ff5555',
    '#95FB79',
    '#FFEE99',
    '#82aaff',
    '#D2A6FF',
    '#82aaff',
    '#ffffff',
  },
  tab_bar = {
    background = '#15161b',
    active_tab = {
      bg_color = '#1e2029',
      fg_color = '#ffffff',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#15161b',
      fg_color = '#5C6773',
      intensity = 'Half',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = '#25282e',
      fg_color = '#ffffff',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    new_tab = {
      bg_color = '#15161b',
      fg_color = '#5C6773',
    },
    new_tab_hover = {
      bg_color = '#25282e',
      fg_color = '#ffffff',
      italic = false,
    },
  },
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 25
config.tab_bar_style = {
  new_tab = ' + ',
  new_tab_hover = ' + ',
}

config.front_end = 'OpenGL'

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}
config.window_close_confirmation = "NeverPrompt"
config.bidi_enabled = true

return config
