local util = require("util")

---@type LazyPluginSpec[]
return {
    { "tpope/vim-surround" },
    { "christoomey/vim-tmux-navigator", },
    { "tpope/vim-repeat", },

    {
        dir = "~/projects/cargo-expand-nvim",
        config = function()
            local Expand = require("cargo-expand")
            util.leader("E", function()
                Expand:expand()
            end)
        end
    },

    {
        "tpope/vim-fugitive",
        lazy = false,
        keys = {
            { "<leader>t", "<cmd>:vertical :Git<cr>" },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                border = true,
                layout_strategy = "horizontal",
                wrap_results = false,
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        height = 0.9,
                        preview_cutoff = 120,
                        prompt_position = "top",
                        width = 0.9,
                    },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            local b = require("telescope.builtin")
            local leader = util.leader

            leader("=", b.spell_suggest)
            leader("T", b.treesitter)
            leader("a", b.autocommands)
            leader("b", b.buffers)
            leader("d", b.diagnostics)
            leader("f", b.find_files)
            leader("g", b.live_grep)
            leader("h", b.help_tags)
            leader('"', b.registers)
            leader("m", b.marks)

            -- LSP
            leader("R", b.lsp_references)
            leader("s", b.lsp_dynamic_workspace_symbols)

            leader("H", function()
                b.find_files({
                    hidden = true,
                    no_ignore = true,
                    no_ignore_parent = true,
                })
            end)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, _)
            require("nvim-treesitter.configs").setup({
                modules = {},
                ignore_install = {},
                auto_install = true,
                ensure_installed = {},
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    {
        "stevearc/oil.nvim",
        opts = {},
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },
}
