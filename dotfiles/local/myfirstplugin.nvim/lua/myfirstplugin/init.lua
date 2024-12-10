local command = require('myfirstplugin.command')
local M = {}

local P = function(thing)
  print(vim.inspect(thing))
end

local startswith = function(str, start)
  return str:sub(1, #start) == start
end

local search_testfunc_name = function()
  local current_node = vim.treesitter.get_node()

  while current_node do
    if 'function_declaration' == current_node:type() then
      break
    end
    current_node = current_node:parent()
  end
  if not current_node then
    return ''
  end

  -- first node will be `func`, so second node is the func name
  return vim.treesitter.get_node_text(current_node:child(1), 0)
end

M.setup = function(opts)
  vim.filetype.add({
    extension = {
      toy = 'toy',
    },
  })

  require('myfirstplugin.timed_highlight').setup()

  vim.api.nvim_create_user_command('Gotest', function()
    local testmod = vim.fn.expand('%:p:h') -- :p expand to full path, :h remove file name
    local testfunc = search_testfunc_name()
    testfunc = testfunc:gsub('\n', ' ')
    if startswith(testfunc, 'Test') then
      local cmd = string.format("go test -v -timeout 30s -run '^%s$' %s", testfunc, testmod)
      command.exec_command(cmd)
    elseif startswith(testfunc, 'Benchmark') then
      local cmd = string.format("go test -v -benchmem -run '^$' -bench '^%s$' %s", testfunc, testmod)
      command.exec_command(cmd)
    else
      print('No valid test found')
    end
  end, {})
end

return M
