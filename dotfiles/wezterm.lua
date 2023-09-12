-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = 'catppuccin-mocha'
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = .8
config.use_fancy_tab_bar = false
config.inactive_pane_hsb = {
  saturation = 0.6,
  brightness = 0.6,
}

config.keys = {
  {
    key = 'o',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    key = 'o',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      -- command = {cwd = '.'},
      -- size = {Percent = 50},
      top_level = true,
    }
  },
  {
    key = 'e',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    key = 'e',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      -- command = {cwd = '.'},
      -- size = {Percent = 50},
      top_level = true,
    }
  },
  {
    key = 'q',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  {
    key = '{',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.RotatePanes 'Clockwise'
  },
  {
    key = '}',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.RotatePanes 'CounterClockwise'
  },
  {
    key = 'p',
    mods = 'CTRL | SHIFT | ALT',
    action = wezterm.action.PaneSelect
  },
  {
    key = "Space",
    mods = "CTRL | SHIFT | ALT",
    action = wezterm.action { QuickSelectArgs = {
      patterns = {
        "https?://\\S+"
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url)
      end)
    } }
  },
}

config.mouse_bindings = {
  -- Scrolling up while holding CTRL increases the font size
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },

  -- Scrolling down while holding CTRL decreases the font size
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
}

-- and finally, return the configuration to wezterm
return config
