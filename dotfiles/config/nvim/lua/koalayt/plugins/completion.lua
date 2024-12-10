return {
  {
    'echasnovski/mini.completion',
    version = false,
    config = function()
      local lspkind_prefix = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      }

      local prettier_lspkind = function()
        for i, v in ipairs(vim.lsp.protocol.CompletionItemKind) do
          local prefix = lspkind_prefix[v]
          if prefix ~= nil and prefix ~= '' then
            vim.lsp.protocol.CompletionItemKind[i] = string.format('%s %s', prefix, v)
          end
        end
      end

      prettier_lspkind()
      require('mini.completion').setup({
        lsp_completion = {
          process_items = function(items, base)
            for _, item in ipairs(items) do
              if item.kind == 15 then
                -- When use <Tab> or <C-n> select this item, show base in text
                -- To expand this snippet, use vim.snippet.expand
                item.textEdit = {
                  newText = base,
                }
              end
            end

            -- Copied from MiniCompletion.default_process_items
            -- But does not filter snippets
            local res = vim.tbl_filter(function(item)
              -- Keep items which match the base
              local text = item.filterText or item.insertText or item.label or ''
              return vim.startswith(text, base)
            end, items)

            table.sort(res, function(a, b) return (a.sortText or a.label) < (b.sortText or b.label) end)

            return res
          end,
        },
      })

      local map = function(mode, lhs, rhs, opts)
        vim.keymap.set(mode, lhs, rhs, opts or { expr = true, })
      end

      map('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
      map('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
      map('i', '<C-j>', function()
        if vim.snippet.active({ direction = -1, }) then
          vim.snippet.jump(-1)
        end
      end, {})
      map('i', '<C-k>', function()
        -- Jump to next position
        if vim.snippet.active({ direction = 1, }) then
          vim.snippet.jump(1)
          return
        end
        -- Do snippet expand
        if vim.fn.pumvisible() ~= 0 then
          local info = vim.fn.complete_info()
          if info.selected ~= -1 then
            local selected_item = info.items[info.selected + 1]
            local success, item = pcall(function() return selected_item.user_data.nvim.lsp.completion_item end)
            if success and item.kind == 15 then
              local cursor = vim.api.nvim_win_get_cursor(0)
              vim.api.nvim_buf_set_text(0,
                cursor[1] - 1, cursor[2] - #item.textEdit.newText,
                cursor[1] - 1, cursor[2],
                {})
              vim.snippet.expand(item.insertText)
            end
          end
        end
      end, {})
    end,
  },
}
