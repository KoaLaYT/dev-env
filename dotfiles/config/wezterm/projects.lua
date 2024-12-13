local wezterm = require('wezterm')
local project_dirs = {
  '/Work/read2n',
  '/Work/metale',
  '/Downloads',
  '/Projects',
  '/Labs',
}

local function all_project_dirs()
  local projects = { wezterm.home_dir, }

  for _, project_dir in ipairs(project_dirs) do
    for _, dir in ipairs(wezterm.glob(wezterm.home_dir .. project_dir .. '/*')) do
      table.insert(projects, dir)
    end
  end

  return projects
end

local function choose_project()
  local choices = {}
  for _, value in ipairs(all_project_dirs()) do
    table.insert(choices, { label = value, })
  end

  return wezterm.action.InputSelector {
    title = 'Projects',
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if not label then return end

      child_window:perform_action(wezterm.action.SwitchToWorkspace {
        name = label:match('([^/]+)$'),
        spawn = { cwd = label, },
      }, child_pane)
    end),
  }
end

local M = {}
M.choose_project = choose_project
return M
