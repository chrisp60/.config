return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = {
                    enabled = true,
                    char = "╎",
                    show_start = true,
                },
                indent = { char = "╎" },
            })
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
        },
    },

    {
        "stevearc/dressing.nvim",
        opts = {},
    },
}
