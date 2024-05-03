local M = {}

--- define a keymap that is available in normal mode and starts with a leader key.
---
--- @param lhs string keys that follow <leader>.
--- @param rhs string|function right hand side of the mapping.
--- @param desc? string a description (merged with opts when provided).
--- @param opts? vim.keymap.set.Opts
function M.leader(lhs, rhs, desc, opts)
    if opts ~= nil then
        opts.desc = desc
    else
        opts = { desc = desc }
    end
    vim.keymap.set("n", "<leader>" .. lhs, rhs, opts)
end

return M
