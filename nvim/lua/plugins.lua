return {
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                -- foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                virtualtext = "~",
            }
        },
        keys = {
            {
                "<leader>css",
                function()
                    local colorizer = require("colorizer")
                    if colorizer.is_buffer_attached() then
                        colorizer.detach_from_buffer()
                    else
                        colorizer.attach_to_buffer()
                    end
                end
            },
        },
    },
    "folke/neodev.nvim",
    {
        "tpope/vim-fugitive",
        lazy = false,
        keys = {
            { "<leader>t", "<cmd>:vertical :Git<cr>" },
        },
    },
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
        dependencies = { "nvim-lua/plenary.nvim" },
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
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            local builtin = require("telescope.builtin")

            local hidden_files = function()
                builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                    no_ignore_parent = true,
                })
            end

            vim.keymap.set("n", "<leader>f", builtin.find_files)
            vim.keymap.set("n", "<leader>g", builtin.live_grep)
            vim.keymap.set("n", "<leader>b", builtin.buffers)
            vim.keymap.set("n", "<leader>h", builtin.help_tags)
            vim.keymap.set("n", "<leader>H", hidden_files)
            vim.keymap.set("n", "<leader>?", builtin.keymaps)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, _)
            require("nvim-treesitter.configs").setup({
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

    {
        "stevearc/oil.nvim",
        opts = {},
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },
}
