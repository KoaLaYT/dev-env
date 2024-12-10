return {
  cmd = { vim.fn.expand('$HOME/.local/luals/bin/lua-language-server'), },
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.uv.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      format = {
        defaultConfig = {
          quote_style = 'single',
          trailing_table_separator = 'always',
        },
      },
      diagnostics = {
        globals = { 'vim', },
      },
    },
  },
}
