return {
    "folke/neodev.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "christoomey/vim-tmux-navigator",
    "tpope/vim-repeat",

    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            popup = { autofocus = true },
        },
        config = function(_, opts)
            local c = require("crates")
            c.setup(opts)
            vim.keymap.set("n", "<leader>ct", c.toggle)
            vim.keymap.set("n", "<leader>cr", c.reload)
            vim.keymap.set("n", "<leader>cv", c.show_versions_popup)
            vim.keymap.set("n", "<leader>cf", c.show_features_popup)
            vim.keymap.set("n", "<leader>ce", c.expand_plain_crate_to_inline_table)
            vim.keymap.set("n", "<leader>cE", c.extract_crate_into_table)
            vim.keymap.set("n", "<leader>cg", c.open_repository)
            vim.keymap.set("n", "<leader>cd", c.open_documentation)
            vim.keymap.set("n", "<leader>cc", c.open_crates_io)
        end,
    },


    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        opts = {
            defaults = {
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
                }
            }
        },
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, _)
            require("nvim-treesitter.configs").setup(
                {
                    auto_install = true,
                    sync_install = false,
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                })
        end,
    },

    {
        "ggandor/leap.nvim",
        dependencies = "tpope/vim-repeat",
        config = function()
            require("leap").add_default_mappings()
        end,
    },
}
