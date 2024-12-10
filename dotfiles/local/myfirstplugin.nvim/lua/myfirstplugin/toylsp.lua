local M = {}

M.setup = function()
    local client = vim.lsp.start_client({
        name = "toylsp",
        cmd = { "go", "run", "/Users/koalayt/Projects/toylsp/cmd/server" },
    })

    if not client then
        vim.notify("start toylsp failed")
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("toylsp", {}),
        pattern = "*.toy",
        callback = function()
            vim.lsp.buf_attach_client(0, client)
        end,
    })
end

return M
