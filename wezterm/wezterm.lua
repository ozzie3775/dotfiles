-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("UDEV Gothic NF")
config.initial_cols = 100
config.initial_rows = 38
config.font_size = 17.0
config.color_scheme = "Dracula (Official)"
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
  { key = "c", mods = "SUPER", action = wezterm.action.SendKey({ key = "c", mods = "ALT" }) },
  { key = "x", mods = "SUPER", action = wezterm.action.SendKey({ key = "x", mods = "META" }) },
  { key = "¥", action = wezterm.action.SendKey({ key = "\\" }) },
}
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

return config
