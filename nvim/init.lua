---@diagnostic disable: undefined-global
require('set')

-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
local plugins = {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        config = function()
            require('colors')
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Loads default behaviour
                    ["core.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { desc = "next hunk [gitsigns]" })
            vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { desc = "prev hunk [gitsigns]" })
        end,

    },
    {
        'mbbill/undotree',
    },
    'tpope/vim-fugitive',
    'NvChad/nvim-colorizer.lua',
    {
        'theprimeagen/harpoon',
        config = function()
            local harpoon = require('harpoon')
            local harpoon_ui = require('harpoon.ui')
            local harpoon_mark = require('harpoon.mark')
            harpoon.setup({ menu = { width = vim.api.nvim_win_get_width(0) - 4, } })
            vim.keymap.set('n', 'gA', function() harpoon_mark.add_file() end, { desc = "add file [harpoon]" })
            vim.keymap.set('n', 'gm', function() harpoon.toggle_quick_menu() end, { desc = "toggle menu [harpoon]" })
            vim.keymap.set('n', 'gj', function() harpoon_ui.nav_file(1) end, { desc = "file 1 [harpoon]" })
            vim.keymap.set('n', 'gk', function() harpoon_ui.nav_file(2) end, { desc = "file 2 [harpoon]" })
            vim.keymap.set('n', 'gl', function() harpoon_ui.nav_file(3) end, { desc = "file 3 [harpoon]" })
            vim.keymap.set('n', 'gh', function() harpoon_ui.nav_file(4) end, { desc = "file 4 [harpoon]" })
        end,
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd
                }
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {} -- this needs to stay or it breaks
    },
    'ThePrimeagen/git-worktree.nvim',
    'christoomey/vim-tmux-navigator',
    'tpope/vim-surround',
    'lukas-reineke/indent-blankline.nvim',
    'nvim-treesitter/playground',
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            -- treesitter
            require 'nvim-treesitter.configs'.setup {
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end

    },
}

require("lazy").setup(plugins, opts)
