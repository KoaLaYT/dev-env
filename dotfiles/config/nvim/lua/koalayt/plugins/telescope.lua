return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.7',
    dependencies = { 'nvim-lua/plenary.nvim', },
    config = function()
      -- native fzf extensions
      -- fzf search syntax: https://github.com/junegunn/fzf#search-syntax
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          prompt_prefix = '> ',
          selection_caret = '󱞩 ',
          winblend = 20,
          layout_strategy = 'vertical',
          layout_config = {
            mirror = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            -- case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      telescope.load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>pf',
        function()
          builtin.find_files({ find_command = { 'fd', '-H', '-t', 'file', }, })
        end,
        {})
      vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
    end,
  },
}
