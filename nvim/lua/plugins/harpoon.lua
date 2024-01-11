return {
    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<C-s>a", function() mark.add_file() end)
            vim.keymap.set("n", "<C-s>m", function() ui.toggle_quick_menu() end)

            vim.keymap.set("n", "<C-s>j", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<C-s>k", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<C-s>l", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<C-s>;", function() ui.nav_file(4) end)

            vim.keymap.set("n", "<C-s>n", function() ui.nav_next() end)
            vim.keymap.set("n", "<C-s>p", function() ui.nav_prev() end)
        end,
    },
}
