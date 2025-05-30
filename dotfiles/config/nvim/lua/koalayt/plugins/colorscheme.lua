return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    -- config = function()
    -- require('catppuccin').setup({
    --   flavour = 'mocha', -- latte, frappe, macchiato, mocha
    --   transparent_background = false,
    --   styles = {
    --     comments = { 'italic', },
    --   },
    --   integrations = {
    --     harpoon = true,
    --   },
    -- })
    --
    -- -- setup must be called before loading
    -- vim.cmd.colorscheme 'catppuccin'
    -- end,
  },
  { 'Mofiqul/dracula.nvim',   lazy = true, },
  { 'lourenci/github-colors', name = 'github-colors', lazy = true, },
  { 'rose-pine/neovim',       name = 'rose-pine',     lazy = true, },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    config = function()
      require('gruvbox').setup({
        -- dim_inactive = true,
        transparent_mode = true,
      })
      vim.cmd.colorscheme('gruvbox')
    end,
  },
}
