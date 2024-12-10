return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons', },
    config = function()
      require('render-markdown').setup({
        enabled = false,
      })
    end,
  },
}
