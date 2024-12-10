return {
  {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup()

      vim.keymap.set(
        'n',
        '<leader>dh',
        '<cmd>DiffviewFileHistory<cr>',
        { desc = 'Repo history', }
      )

      vim.keymap.set(
        'n',
        '<leader>df',
        '<cmd>DiffviewFileHistory --follow %<cr>',
        { desc = 'File history', }
      )

      vim.keymap.set(
        'v',
        '<leader>dl',
        "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>",
        { desc = 'Range history', }
      )
    end,
  },
}
