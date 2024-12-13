local wezterm = require('wezterm')
local config = wezterm.config_builder()
local projects = require('projects')
local navi = require('navi')

-- MonaspiceNe Nerd Font Propo
config.font = wezterm.font_with_fallback({ 'JetBrainsMono Nerd Font', 'PingFang SC', })
config.font_size = 16.5
config.line_height = 1.0
config.color_scheme = 'GruvboxDark'

config.window_padding = {
  left = 20,
  right = 20,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  font = wezterm.font({ family = 'JetBrainsMono Nerd Font', weight = 'Bold', }),
  font_size = 14,
}
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.background = {
  {
    source = {
      Color = '#000000',
    },
    opacity = 0.85,
    width = '100%',
    height = '100%',
  },
}
config.macos_window_background_blur = 10

config.leader = {
  key = 'a', mods = 'CTRL', timeout_milliseconds = 10000,
}
wezterm.on('update-status', function(window, _pane)
  local status = window:active_workspace()
  if window:leader_is_active() then
    status = '👑 ' .. status
  else
    status = '🖥️ ' .. status
  end
  window:set_left_status(wezterm.format({
    { Background = { Color = '#2b2042', }, },
    { Foreground = { Color = '#722529', }, },
    { Text = ' ', },
    { Background = { Color = '#722529', }, },
    { Foreground = { Color = '#c0c0c0', }, },
    { Text = status, },
    { Background = { Color = '#2b2042', }, },
    { Foreground = { Color = '#722529', }, },
    { Text = ' ', },
  }))
end)

config.keys = {
  -- Actually send CTRL + A key to the terminal
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL', },
  },
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal({
      domain = 'CurrentPaneDomain',
    }),
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical({
      domain = 'CurrentPaneDomain',
    }),
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = projects.choose_project(),
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES', }),
  },
  -- navi with nvim aware
  table.unpack(navi),
}
for i = 1, 5 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CMD',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
