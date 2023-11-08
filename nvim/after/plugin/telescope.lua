require("telescope").setup({
    defaults = {
        wrap_results = true,
        border = true,
        sorting_strategy = "ascending",
    },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>h", function()
    builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end)

vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "[tele] keymaps" })
vim.keymap.set("n", "<leader>H", builtin.help_tags, { desc = "[tele] help_tags" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[tele] buffers" })
vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "[tele] diagnostics" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[tele] find_files" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "[tele] live_grep" })
vim.keymap.set("n", "<leader>p", builtin.registers, { desc = "[tele] registers" })

vim.keymap.set("n", "<leader>st", builtin.lsp_type_definitions, { desc = "[tele] type defs" })
vim.keymap.set("n", "<leader>sd", builtin.lsp_document_symbols, { desc = "[tele] document symbols" })
vim.keymap.set("n", "<leader>sw", builtin.lsp_workspace_symbols, { desc = "[tele] lsp_workspace_symbols" })
vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "[tele] references" })
