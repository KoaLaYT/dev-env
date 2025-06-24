local api, lsp = vim.api, vim.lsp

api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`', })

local complete_client = function(arg)
  return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
end

local complete_config = function(arg)
  return vim
      .iter(vim.api.nvim_get_runtime_file(('lsp/%s*.lua'):format(arg), true))
      :map(function(path)
        local file_name = path:match('[^/]*.lua$')
        return file_name:sub(0, #file_name - 4)
      end)
      :totable()
end

api.nvim_create_user_command('LspStart', function(info)
  if vim.lsp.config[info.args] == nil then
    vim.notify(("Invalid server name '%s'"):format(info.args))
    return
  end

  vim.lsp.enable(info.args)
end, {
  desc = 'Enable and launch a language server',
  nargs = '?',
  complete = complete_config,
})

api.nvim_create_user_command('LspRestart', function(info)
  for _, name in ipairs(info.fargs) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(info.fargs) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = 'Restart the given client(s)',
  nargs = '+',
  complete = complete_client,
})

api.nvim_create_user_command('LspStop', function(info)
  for _, name in ipairs(info.fargs) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
    else
      vim.lsp.enable(name, false)
    end
  end
end, {
  desc = 'Disable and stop the given client(s)',
  nargs = '+',
  complete = complete_client,
})

api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})
