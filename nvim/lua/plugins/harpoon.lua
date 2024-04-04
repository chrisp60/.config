return {
    {
        "theprimeagen/harpoon",
        config = function()
            require("harpoon").setup({
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 4,
                },
            })
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "sa", function()
                mark.add_file()
            end)
            vim.keymap.set("n", "sm", function()
                ui.toggle_quick_menu()
            end)
            vim.keymap.set("n", "sj", function()
                ui.nav_file(1)
            end)
            vim.keymap.set("n", "sk", function()
                ui.nav_file(2)
            end)
            vim.keymap.set("n", "sl", function()
                ui.nav_file(3)
            end)
            vim.keymap.set("n", "s;", function()
                ui.nav_file(4)
            end)
            vim.keymap.set("n", "sn", function()
                ui.nav_next()
            end)
            vim.keymap.set("n", "sp", function()
                ui.nav_prev()
            end)
        end,
    },
}
