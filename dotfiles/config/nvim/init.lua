vim.g.mapleader = ' '

local map = function(mode, lhs, rhs, opts)
  local default_opts = {
    noremap = true,
  }
  local final_opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

map('i', 'jk', '<Esc>')
map('n', '<leader>pv', function() vim.cmd('Explore') end)

-- Keep cursor when up and down
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- For tinkering nvim config
map('n', '<leader><leader>x', ':w<CR>:source %<CR>')      -- exec current lua file
map('n', '<leader><leader>t', ':PlenaryBustedFile %<CR>') -- test current lua file
map('n', '<leader><leader>e', function()
  require('telescope.builtin').find_files {
    cwd = '~/.config/nvim',
  }
end)

-- Note taking
map('n', '<leader>nn', function()
  local now = os.date('%Y%m%d_%H%M')
  vim.cmd(string.format('vs ~/Notes/temp/%s.md', now))
end)
map('n', '<leader>nt', function()
  local now = os.date('%Y%m%d')
  vim.cmd(string.format('vs ~/Notes/%s.md', now))
end)
map('n', '<leader>nd', ':vs ~/Notes/TODO.md<CR>')
map('n', '<leader>nv', ':RenderMarkdown toggle<CR>')

-- Move visual select blocks up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Copy to clipboard
map('v', '<leader>y', '"+y')
map('n', '<leader>Y', '"+yg_')
map('n', '<leader>y', '"+y')
map('n', '<leader>yy', '"+yy')

-- Paste from clipboard
map('n', '<leader>p', '"+p')
map('n', '<leader>P', '"+P')
map('v', '<leader>p', '"+p')
map('v', '<leader>P', '"+P')

-- Mainly selected and copied from "mini.basics"
local o       = vim.opt

-- General
o.undofile    = false                -- Enable persistent undo (see also `:h undodir`)
o.backup      = false                -- Don't store backup while overwriting the file
o.writebackup = false                -- Don't store backup while overwriting the file
o.mouse       = 'a'                  -- Enable mouse for all available modes
vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- Appearance
o.breakindent    = true  -- Indent wrapped lines to match line start
o.cursorline     = true  -- Highlight current line
o.linebreak      = true  -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.number         = true  -- Show line numbers
o.relativenumber = true
o.splitright     = true  -- Vertical splits will be to the right
o.wrap           = false -- Display long lines as just one line
o.signcolumn     = 'yes' -- Always show sign column (otherwise it will shift text)
o.termguicolors  = true  -- Enable gui colors
o.pumblend       = 10    -- Make builtin completion menus slightly transparent
o.pumheight      = 10    -- Make popup menu smaller
o.list           = true  -- Show some helper symbols
o.listchars      = {
  nbsp = '+',
  tab = '» ',
  trail = '·',
  -- eol = "␤",
}
o.colorcolumn    = '+1,+2' -- Draw line one column after `textwidth`
o.scrolloff      = 8
o.isfname:append('@-@')
o.updatetime = 50

local function set_diagnostic_signs()
  local symbols = { Error = '❗', Info = 'ℹ️', Hint = '💡', Warn = '⚠️', }
  for name, icon in pairs(symbols) do
    local hl = 'DiagnosticSign' .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl, })
  end
end
set_diagnostic_signs()

-- Editing
o.textwidth     = 120
o.tabstop       = 4
o.softtabstop   = 4
o.shiftwidth    = 4
o.expandtab     = true
o.ignorecase    = true    -- Ignore case when searching (use `\C` to force not doing that)
o.incsearch     = true    -- Show search results while typing
o.infercase     = true    -- Infer letter cases for a richer built-in keyword completion
o.smartcase     = true    -- Don't ignore case when searching if pattern has upper case
o.smartindent   = true    -- Make indenting smart
o.virtualedit   = 'block' -- Allow going past the end of line in visual block mode
o.formatoptions = 'qjl1'  -- Don't autoformat comments
o.shortmess:append('WcC') -- Reduce command line messages
o.splitkeep = 'screen'    -- Reduce scroll during window split

require('koalayt.lspsettings')

-- Lazy plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('koalayt.plugins',
  {
    ui = {
      border = 'single',
    },
  }
)
