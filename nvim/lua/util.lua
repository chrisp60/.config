local M = {}

---Returns true if any line in the buffer contains the literal string
---@param bufnr? integer Buffer number to search (default 0)
---@param lit string Literal string to match
---@return boolean true if string is found
function M.buf_has_str(bufnr, lit)
    local lines = vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)
    -- I don't know if this breaks on true of iterates until the end.
    return vim.iter(lines):any(function(content)
        return content:match(lit)
    end)
end

M.handle_formatting = function()
    local filetype = vim.filetype.match({ buf = 0 })
    if filetype == "rust" and M.buf_has_str(0, "leptos") then
        vim.cmd.write()
        vim.cmd([[silent! leptosfmt % -t 2]])
        vim.notify("using leptos", vim.log.levels.INFO)
    elseif filetype == "lua" then
        require("stylua").format()
    elseif filetype == "lua" then
    else
        vim.lsp.buf.format()
    end
end

function M.handle_diagnostics()
    vim.keymap.set({ "n", "v" }, "<leader>D", vim.diagnostic.setqflist, { desc = "[qflist] next" })
    vim.keymap.set({ "n", "v" }, "gn", "<cmd>cn<CR>", { desc = "[qflist] next" })
    vim.keymap.set({ "n", "v" }, "gp", "<cmd>cp<CR>", { desc = "[qflist] pref" })
end

M.handle_diagnostics()

return M
