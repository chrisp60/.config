return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        name = "ibl",
        opts = {
            scope = {
                enabled = true,
                char = "╎",
                show_start = true,
            },
            indent = { char = "╎" },
        },
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    {
        'stevearc/dressing.nvim',
        opts = {},
    }
}
