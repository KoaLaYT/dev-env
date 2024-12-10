local M = {}

local highlight_timer
local highlight_expiration_time = 2000

M.turnoff_highlight_after_expiration = function()
    if highlight_timer then
        vim.fn.timer_stop(highlight_timer)
    end

    highlight_timer = vim.fn.timer_start(highlight_expiration_time, function()
        vim.cmd('nohlsearch')
    end)
end

M.setup = function()
    local cmd = ":lua require('myfirstplugin.timed_highlight').turnoff_highlight_after_expiration()<CR>"

    vim.api.nvim_set_keymap('n', '*', string.format('*N%s', cmd), { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '#', string.format('#N%s', cmd), { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'n', string.format('nzzzv%s', cmd), { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'N', string.format('Nzzzv%s', cmd), { noremap = true, silent = true })

    vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
        callback = function(ev)
            local cmd_type = vim.fn.expand("<afile>")
            vim.schedule(function()
                if cmd_type ~= nil and (cmd_type == '/' or cmd_type == '?') then
                    require('myfirstplugin.timed_highlight').turnoff_highlight_after_expiration()
                end
            end)
        end
    })
end

return M
