return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            vim.keymap.set("n", "sa", function() harpoon:list():add() end)
            vim.keymap.set("n", "sm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "sj", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "sk", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "sl", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "s;", function() harpoon:list():select(4) end)
            vim.keymap.set("n", "sp", function() harpoon:list():prev() end)
            vim.keymap.set("n", "sn", function() harpoon:list():next() end)
        end,
    },
}
