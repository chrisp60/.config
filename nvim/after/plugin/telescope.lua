require("telescope").setup({
    defaults = {
        layout_strategy = "bottom_pane",
        wrap_results = true,
        border = false,
        sorting_strategy = "ascending",
        winblend = 10,
    },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>h", function()
    builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end)

vim.keymap.set("n", "<leader>'", builtin.marks, { desc = "[telescope] marks" })
vim.keymap.set("n", "<leader>K", builtin.keymaps, { desc = "[telescope] keymaps" })
vim.keymap.set("n", "<leader>/", builtin.search_history, { desc = "[telescope] search_history" })
vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "[telescope] keymaps" })
vim.keymap.set(
    "n",
    "<leader>F",
    builtin.current_buffer_fuzzy_find,
    { desc = "[telescope] current_buffer_fuzzy_find" }
)
vim.keymap.set("n", "<leader>H", builtin.help_tags, { desc = "[telescope] help_tags" })
vim.keymap.set("n", "<leader>J", builtin.jumplist, { desc = "[telescope] jumplist" })
vim.keymap.set("n", "<leader>U", builtin.resume, { desc = "[telescope] resume" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[telescope] buffers" })
vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "[telescope] diagnostics" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[telescope] find_files" })
vim.keymap.set("n", "<leader>gg", builtin.live_grep, { desc = "[telescope] live_grep" })
vim.keymap.set("n", "<leader>gB", builtin.git_bcommits, { desc = "[telescope] git_bcommits" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[telescope] git_branches" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[telescope] git_commits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[telescope] git_status" })
vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "[telescope] lsp_definitions" })
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, { desc = "[telescope] lsp_implementations" })
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "[telescope] lsp_references" })
vim.keymap.set("n", "<leader>lt", builtin.lsp_type_definitions, { desc = "[telescope] lsp_type_definitions" })
vim.keymap.set("n", "<leader>lS", builtin.lsp_workspace_symbols, { desc = "[telescope] lsp_workspace_symbols" })
vim.keymap.set(
    "n",
    "<leader>ls",
    builtin.lsp_dynamic_workspace_symbols,
    { desc = "[telescope] lsp_dynamic_workspace_symbols" }
)
vim.keymap.set("n", "<leader>m", builtin.man_pages, { desc = "[telescope] man_pages" })
vim.keymap.set("n", "<leader>t", builtin.treesitter)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>")
vim.keymap.set("n", '<leader>"', builtin.registers)
