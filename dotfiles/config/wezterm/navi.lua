local wezterm = require('wezterm')
local act = require('wezterm').action
local mux = require('wezterm').mux

local nvim = '/usr/local/bin/nvim' -- change this to the location of you nvim

local wez_nvim_action = function(window, pane, action_wez, forward_key_nvim)
  local current_process = mux.get_window(window:window_id()):active_pane():get_foreground_process_name()
  if current_process == nvim then
    window:perform_action(forward_key_nvim, pane)
  else
    window:perform_action(action_wez, pane)
  end
end

wezterm.on('move-left', function(window, pane)
  wez_nvim_action(window, pane,
    act.ActivatePaneDirection 'Left',
    act.SendKey({ key = 'h', mods = 'CTRL', })
  )
end)

wezterm.on('move-right', function(window, pane)
  wez_nvim_action(window, pane,
    act.ActivatePaneDirection 'Right',
    act.SendKey({ key = 'l', mods = 'CTRL', }))
end)

wezterm.on('move-down', function(window, pane)
  wez_nvim_action(window, pane,
    act.ActivatePaneDirection 'Down',
    act.SendKey({ key = 'j', mods = 'CTRL', }))
end)

wezterm.on('move-up', function(window, pane)
  wez_nvim_action(window, pane,
    act.ActivatePaneDirection 'Up',
    act.SendKey({ key = 'k', mods = 'CTRL', }))
end)

return {
  { key = 'h', mods = 'CTRL', action = wezterm.action({ EmitEvent = 'move-left', }), },
  { key = 'l', mods = 'CTRL', action = wezterm.action({ EmitEvent = 'move-right', }), },
  { key = 'j', mods = 'CTRL', action = wezterm.action({ EmitEvent = 'move-down', }), },
  { key = 'k', mods = 'CTRL', action = wezterm.action({ EmitEvent = 'move-up', }), },
}
