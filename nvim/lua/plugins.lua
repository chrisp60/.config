local util = require("util")

---@type LazyPluginSpec
local spec = {
    "tpope/vim-surround",
    "christoomey/vim-tmux-navigator",
    "tpope/vim-repeat",

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gitsigns = require("gitsigns")
            gitsigns.setup({
                on_attach = function()
                    util.normal_leader("Gs", function()
                        gitsigns.stage_hunk()
                    end)
                    util.normal_leader("Gu", function()
                        gitsigns.undo_stage_hunk()
                    end)
                    util.normal_leader("Gb", function()
                        gitsigns.stage_buffer()
                    end)
                    util.normal_leader("Gn", function()
                        gitsigns.nav_hunk("next")
                    end)
                    util.normal_leader("Gp", function()
                        gitsigns.nav_hunk("prev")
                    end)
                end,
            })
        end,
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
            local leader = util.normal_leader

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

return spec
