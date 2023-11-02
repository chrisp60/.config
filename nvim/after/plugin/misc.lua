-- Telescope
local builtin = require("telescope.builtin")
local include_hidden = { hidden = true, no_ignore = true, no_ignore_parent = true }

vim.keymap.set("n", "<leader>H", function()
    builtin.find_files(include_hidden)
end)

vim.keymap.set("n", "<leader>/", builtin.search_history)
vim.keymap.set("n", "<leader>C", builtin.command_history)
vim.keymap.set("n", "<leader>G", builtin.live_grep)
vim.keymap.set("n", "<leader>J", builtin.jumplist)
vim.keymap.set("n", "<leader>Li", builtin.lsp_incoming_calls)
vim.keymap.set("n", "<leader>Lo", builtin.lsp_outgoing_calls)
vim.keymap.set("n", "<leader>R", builtin.lsp_references)
vim.keymap.set("n", "<leader>S", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>Z", builtin.spell_suggest)
vim.keymap.set("n", "<leader>\"", builtin.registers)
vim.keymap.set("n", "<leader>'", builtin.marks)
vim.keymap.set("n", "<leader>b", builtin.git_branches)
vim.keymap.set("n", "<leader>c", builtin.git_commits)
vim.keymap.set("n", "<leader>d", builtin.diagnostics)
vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>h", builtin.help_tags)
vim.keymap.set("n", "<leader>i", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>")

vim.keymap.set("n", "gc", function()
    require("nvim-highlight-colors").toggle()
end, { silent = true })

-- Harpoon
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 20,
    },
    global_settings = {
        mark_branch = true,
        save_on_change = true,
        save_on_toggle = true,
        tabline = false,
    },
})

vim.keymap.set("n", "<leader>j", function()
    harpoon_ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>k", function()
    harpoon_ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>l", function()
    harpoon_ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>;", function()
    harpoon_ui.nav_file(4)
end)
vim.keymap.set("n", "<leader>F", harpoon_mark.add_file)
vim.keymap.set("n", "<leader>n", harpoon_ui.nav_next)
vim.keymap.set("n", "<leader>p", harpoon_ui.nav_prev)
vim.keymap.set("n", "<leader>m", harpoon_ui.toggle_quick_menu)
