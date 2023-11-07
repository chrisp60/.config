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
        mark_branch = false,
        save_on_change = true,
        save_on_toggle = false,
        tabline = true,
    },
})

local function harp(num)
    harpoon_ui.nav_file(num)
end

vim.keymap.set("n", "gC", "<cmd>tab Git<cr>", { desc = "Git in tab" })
vim.keymap.set("n", "gc", "<cmd>vert Git<cr>", { desc = "Get in vertical" })
vim.keymap.set("n", "gj", function() harp(1) end, { desc = "[harp] nav 1" })
vim.keymap.set("n", "gk", function() harp(2) end, { desc = "[harp] nav 2" })
vim.keymap.set("n", "gl", function() harp(3) end, { desc = "[harp] nav 3" })
vim.keymap.set("n", "gh", function() harp(4) end, { desc = "[harp] nav 4" })
vim.keymap.set("n", "gA", harpoon_mark.add_file, { desc = "[harp] add_file" })
vim.keymap.set("n", "gm", harpoon_ui.toggle_quick_menu, { desc = "[harp] toggle_quick_menu" })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "zen mod" })
