vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.path:append("**")
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 10
vim.opt.wrap = false

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
        "catppuccin/nvim",
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                -- height and width can be:
                -- * an absolute number of cells when > 1
                -- * a percentage of the width / height of the editor when <= 1
                -- * a function that returns the width or the height
                width = 120, -- width of the Zen window
                height = 1,  -- height of the Zen window
                -- by default, no options are changed for the Zen window
                -- uncomment any of the options below, or add other vim.wo options you want to apply
                options = {
                    signcolumn = "no",     -- disable signcolumn
                    number = true,         -- disable number column
                    relativenumber = true, -- disable relative numbers
                    cursorline = true,     -- disable cursorline
                    cursorcolumn = false,  -- disable cursor column
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,   -- disables the ruler text in the cmd line area
                    showcmd = false, -- disables the command in the last line of the screen
                    laststatus = 0,  -- turn off the statusline in zen mode
                },
                twilight = { enabled = false },
                tmux = { enabled = true }, -- disables the tmux statusline
                wezterm = {
                    enabled = true,
                    font = "+20", -- (10% increase per step)
                },
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            require("ibl").setup({
                scope = { enabled = true, char = "╎", show_start = true },
                indent = { char = "╎" },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter", "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup({
                load = {
                    ["core.summary"] = { config = { stragegy = "default" } },
                    ["core.completion"] = { config = { engine = "nvim-cmp" } },
                    ["core.concealer"] = {},
                    ["core.ui.calendar"] = {},
                    ["core.export"] = {
                        config = {
                            export_dir = "exports/<export-dir>/<language>",
                        },
                    },
                    ["core.export.markdown"] = {},
                    ["core.defaults"] = {},
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        cmd = "TSUpdate",
        config = function()
            ---@diagnostic disable-next-line missing-fields
            require("nvim-treesitter.configs").setup({
                sync_install = true,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    "brenoprata10/nvim-highlight-colors",
    "L3MON4D3/LuaSnip",
    "christoomey/vim-tmux-navigator",
    "folke/neodev.nvim",
    "lukas-reineke/lsp-format.nvim",
    "mbbill/undotree",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/playground",
    "saadparwaiz1/cmp_luasnip",
    "theprimeagen/harpoon",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "wesleimp/stylua.nvim",
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
}

require("lazy").setup(plugins)
