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


return M
