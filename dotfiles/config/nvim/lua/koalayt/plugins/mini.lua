return {
  {
    'echasnovski/mini.statusline',
    version = false,
    config = true,
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = true,
  },
  {
    'echasnovski/mini.diff',
    version = false,
    config = function()
      require('mini.diff').setup({
        view = {
          style = 'sign',
        },
      })
      vim.keymap.set('n', '<leader>go', function()
        MiniDiff.toggle_overlay()
      end, {})
    end,
  },
  {
    'echasnovski/mini-git',
    version = false,
    main = 'mini.git',
    config = function()
      require('mini.git').setup()
    end,
  },
  {
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup()
    end,
  },
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup()
    end,
  },
}
