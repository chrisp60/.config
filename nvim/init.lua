vim.g.mapleader = " "
vim.opt.cmdwinheight = 7
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorcolumn = false
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.path:append("**")
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 10
vim.opt.wrap = false

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
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
require("lazy").setup({
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
    },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
    },
    {
        "saadparwaiz1/cmp_luasnip",
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    cmp = true,
                    leap = true,
                    native_lsp = { enabled = true },
                    harpoon = true,
                    cmp = true,
                    telescope = true,
                    semantic_tokens = true
                }
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    auto_refresh = true,
                    enabled = true,
                    keymap = { open = "<C-D>", refresh = "<C-F>" },
                    layout = { position = "right", ratio = 0.45 },
                },
                suggestion = {
                    enabled = false,
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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
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
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                                projects = "~/projects",
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "pwntester/octo.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require("octo").setup({
                file_panel = {
                    use_icons = false,
                }
            })
        end,
    },
    { "folke/zen-mode.nvim" },
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow",
    },
    { "folke/neodev.nvim" },
    { "theprimeagen/harpoon" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-surround" },
    { "christoomey/vim-tmux-navigator" },
    {
        "ggandor/leap.nvim",
        lazy = false,
        dependencies = "tpope/vim-repeat",
        config = function()
            require('leap').add_default_mappings()
        end
    },
    { "wesleimp/stylua.nvim" },
})

vim.cmd.colorscheme("catppuccin-" .. os.getenv("CATPPUCCIN_FLAVOUR") or "mocha")

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function()
    lsp_zero.buffer_autoformat()
    vim.keymap.set("n", "<leader>o", function()
        vim.cmd([[silent ! leptosfmt % -t 2 -m 80]])
    end)
    local builtin = require("telescope.builtin")
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
    vim.keymap.set("n", "<leader>R", builtin.lsp_references)
    vim.keymap.set("n", "<leader>S", builtin.lsp_document_symbols)
    vim.keymap.set("n", "<leader>d", builtin.diagnostics)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)
    vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action)

    vim.keymap.set({ "n", "v", "x" }, "<leader>i", function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
    end)
end)

vim.diagnostic.config({ signs = false, virtual_text = false, underline = false })

local function rust_analyzer_config()
    require("lspconfig")["rust_analyzer"].setup({
        settings = {
            ["rust-analyzer"] = {
                cargo = { features = "all" },
                check = {
                    features = "all",
                    ignore = { "inactive-code", "unlinked-file" },
                    command = "clippy",
                },
            },
        },
    })
end

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {},
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls({}))
        end,
        rust_analyzer = rust_analyzer_config,
    },
})

-- nvim cmp
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local comp = {
    config = {
        sources = {
            { name = "copilot" },
            { name = "nvim_lsp" },
        },
    },
}
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "copilot" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
    },
    mapping = cmp.mapping.preset.insert({
        -- select cmp options
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-t>"] = cmp.mapping.complete(comp),
    }),
    formatting = require("lsp-zero").cmp_format(),
})

-- Telescope
local builtin = require("telescope.builtin")
require("telescope").setup({
    defaults = {
        wrap_results = true,
        border = true,
        sorting_strategy = "ascending",
    },
})

vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>g", builtin.live_grep)
vim.keymap.set("n", "<leader>b", builtin.buffers)
vim.keymap.set("n", "<leader>h", builtin.help_tags)
vim.keymap.set("n", "<leader>H", function()
    builtin.find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true
    })
end)
vim.keymap.set("n", "<leader>?", builtin.keymaps)

-- Harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>1", function()
    harpoon_ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>2", function()
    harpoon_ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>3", function()
    harpoon_ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>4", function()
    harpoon_ui.nav_file(4)
end)
vim.keymap.set("n", "gA", harpoon_mark.add_file)
vim.keymap.set("n", "gm", harpoon_ui.toggle_quick_menu)

-- Zen
vim.keymap.set("n", "<leader>z", require("zen-mode").toggle)
