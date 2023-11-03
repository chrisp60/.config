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

vim.keymap.set("n", "<leader>'", builtin.marks)
vim.keymap.set("n", "<leader>/", builtin.search_history)
vim.keymap.set("n", "<leader>?", builtin.keymaps)
vim.keymap.set("n", "<leader>F", builtin.current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>H", builtin.help_tags)
vim.keymap.set("n", "<leader>J", builtin.jumplist)
vim.keymap.set("n", "<leader>U", builtin.resume)
vim.keymap.set("n", "<leader>b", builtin.buffers)
vim.keymap.set("n", "<leader>d", builtin.diagnostics)
vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>g", builtin.live_grep)
vim.keymap.set("n", "<leader>gB", builtin.git_bcommits)
vim.keymap.set("n", "<leader>gb", builtin.git_branches)
vim.keymap.set("n", "<leader>gc", builtin.git_commits)
vim.keymap.set("n", "<leader>gs", builtin.git_status)
vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions)
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
vim.keymap.set("n", "<leader>lt", builtin.lsp_type_definitions)
vim.keymap.set("n", "<leader>lS", builtin.lsp_workspace_symbols)
vim.keymap.set("n", "<leader>ls", builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set("n", "<leader>m", builtin.man_pages)
vim.keymap.set("n", "<leader>t", builtin.treesitter)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>")
vim.keymap.set("n", '<leader>"', builtin.registers)
