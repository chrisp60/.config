---@type LazyPluginSpec[]
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
        opts = {
            integrations = {
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "bold" },
                        hints = { "bold" },
                        warnings = { "bold" },
                        information = { "bold" },
                    },
                    inlay_hints = {
                        background = false,
                    },
                },
            },
            highlight_overrides = {
                all = function(colors)
                    return {
                        ["@lsp.typemod.function.defaultLibrary.rust"] = { fg = colors.sapphire },
                        ["@lsp.type.decorator"] = { fg = colors.blue },
                        ["@lsp.type.unresolvedReference"] = {
                            fg = colors.red
                        },
                    }
                end,
            },
        },
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
