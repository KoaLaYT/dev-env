local M = {}

local display_bufnr = -1

local write_to_buf = function(_, data)
    vim.api.nvim_buf_set_lines(display_bufnr, -1, -1, true, data)
end

local is_buf_visible = function(bufnr)
    local windows = vim.fn.win_findbuf(bufnr)
    return #windows > 0
end

M.exec_command = function(command)
    -- previous split window maybe closed or opened other buffers
    -- need to split a new one
    if not is_buf_visible(display_bufnr) then
        local cur_win = vim.api.nvim_get_current_win()
        display_bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_command("botright vsplit")                         -- split a new window
        vim.api.nvim_command(string.format("buffer %d", display_bufnr)) -- attach `display_buf` to this window
        vim.api.nvim_set_current_win(cur_win)                           -- switch back, otherwise the cursor will be in `scratch`
    end

    vim.api.nvim_buf_set_lines(display_bufnr, 0, -1, true, {
        "Run command: ",
        command,
        "-----------------------"
    })
    vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = write_to_buf,
        stderr_buffered = true,
        on_stderr = write_to_buf,
    })
end

return M
