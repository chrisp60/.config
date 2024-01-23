return {

    {
        "NoahTheDuke/vim-just",
        ft = { "just" },
    },
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

            vim.keymap.set("n", "<leader>f", builtin.lsp_outgoing_calls)
            vim.keymap.set("n", "<leader>f", builtin.lsp_outgoing_calls)
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
        "stevearc/oil.nvim",
        opts = {},
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },
}
