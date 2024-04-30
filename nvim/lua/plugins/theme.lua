return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    gitsigns = true,
                    mason = true,
                    notify = true,
                    markdown = true,
                    indent_blankline = true,
                    harpoon = true,
                    telescope = true,
                    treesitter = true,
                    native_lsp = true,
                    semantic_tokens = true,
                },
            })
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
