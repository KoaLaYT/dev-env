return {
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          -- lua = { "stylua" },
          javascript = { 'prettier', },
          typescript = { 'prettier', },
          typescriptreact = { 'prettier', },
          json = { 'prettier', },
          yaml = { 'prettier', },
          css = { 'prettier', },
        },
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_fallback = false,
        },
      })
    end,
  },
}
