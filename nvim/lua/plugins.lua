---@type LazyPluginSpec[]
return {
    { "tpope/vim-surround" },
    { "christoomey/vim-tmux-navigator" },
    { "tpope/vim-repeat" },

    {
        dir = "~/projects/cargo-expand-nvim",
        config = function()
            vim.keymap.set("n", "<leader>E", function()
                require("cargo-expand"):expand()
            end)
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
            local tele = require("telescope.builtin")

            local setnl = function(arg, f)
                vim.keymap.set("n", "<leader>" .. arg, f)
            end

            setnl("=", tele.spell_suggest)
            setnl("T", tele.treesitter)
            setnl("a", tele.autocommands)
            setnl("b", tele.buffers)
            setnl("d", tele.diagnostics)
            setnl("f", tele.find_files)
            setnl("g", tele.live_grep)
            setnl("h", tele.help_tags)
            setnl('"', tele.registers)
            setnl("m", tele.marks)
            setnl("R", tele.lsp_references)
            setnl("s", tele.lsp_dynamic_workspace_symbols)
            setnl("H", function()
                tele.find_files({
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
