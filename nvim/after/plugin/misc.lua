vim.keymap.set("n", "<leader>x", "\"_")
vim.keymap.set("n", "<leader>E", ":Explore<CR>")
vim.keymap.set("n", "<leader>css", function()
    require("nvim-highlight-colors").toggle()
end, { silent = true })

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

vim.keymap.set("n", "gj", function()
    harpoon_ui.nav_file(1)
end)
vim.keymap.set("n", "gk", function()
    harpoon_ui.nav_file(2)
end)
vim.keymap.set("n", "gl", function()
    harpoon_ui.nav_file(3)
end)
vim.keymap.set("n", "g;", function()
    harpoon_ui.nav_file(4)
end)
vim.keymap.set("n", "gA", harpoon_mark.add_file)
vim.keymap.set("n", "gm", harpoon_ui.toggle_quick_menu)
