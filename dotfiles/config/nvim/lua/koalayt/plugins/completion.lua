return {
  {
    'echasnovski/mini.completion',
    version = false,
    config = function()
      require('mini.completion').setup()


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
