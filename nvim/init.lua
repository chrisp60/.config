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
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 10
vim.opt.wrap = false

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
require("lazy").setup({
    --- Uncomment these if you want to manage LSP servers from neovim
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "VonHeikemen/lsp-zero.nvim",        branch = "v3.x" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "catppuccin/nvim",                   name = "catppuccin", priority = 1000 },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                auto_install = true,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
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

    { "brenoprata10/nvim-highlight-colors" },
    { "theprimeagen/harpoon" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-surround" },
    { "wesleimp/stylua.nvim" },
    { "christoomey/vim-tmux-navigator" },
    { "lukas-reineke/lsp-format.nvim" },
    { "wesleimp/stylua.nvim" },
})

-- *********************************
-- Plugin Config
-- *********************************

-- Load colorscheme
vim.cmd.colorscheme("catppuccin")

-- LSP config stolen directly from
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md#primes-config

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local function opts_desc(desc)
        return { buffer = bufnr, remap = false, desc = desc }
    end

    vim.cmd([[autocmd BufWritePre *.lua lua require('stylua').format()]])

    lsp_zero.buffer_autoformat()

    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts_desc("Go to Definition [LSP]"))

    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts_desc("Show hover [LSP]"))

    vim.keymap.set("n", "<leader>s", function()
        vim.lsp.buf.workspace_symbol()
    end, opts_desc("Workspace Symbol [LSP]"))

    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
    end, opts_desc("Open Float [LSP]"))

    vim.keymap.set("n", "gn", function()
        vim.diagnostic.goto_next()
    end, opts_desc("Next Diagnostic [LSP]"))

    vim.keymap.set("n", "gp", function()
        vim.diagnostic.goto_prev()
    end, opts_desc("Previous Diagnostic [LSP]"))

    vim.keymap.set("n", "<leader>a", function()
        vim.lsp.buf.code_action()
    end, opts_desc("Code Action [LSP]"))

    vim.keymap.set("n", "<leader>R", function()
        vim.lsp.buf.references()
    end, opts_desc("References [LSP]"))

    vim.keymap.set("n", "<leader>r", function()
        vim.lsp.buf.rename()
    end, opts_desc("Rename All [LSP]"))

    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts_desc("Signature Help [LSP]"))
end)

-- Mason & LSP
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "cssls", "taplo", "lua_ls" },
    handlers = {
        lsp_zero.default_setup,

        lua_ls = function()
            require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls({}))
        end,

        rust_analyzer = function()
            require("lspconfig").rust_analyzer.setup({
                cargo = {
                    features = "all",
                },
                completion = {
                    fullFunctionSignatures = {
                        enable = true,
                    },
                },
            })
        end,
    },
})

-- nvim cmp
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
    },
    mapping = cmp.mapping.preset.insert({
        -- select cmp options
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),

        -- luasnip movements
        ["<C-n>"] = cmp_action.luasnip_jump_forward(),
        ["<C-p>"] = cmp_action.luasnip_jump_backward(),

        -- Invoke cmp menu manually
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    formatting = require("lsp-zero").cmp_format(),
})

-- Highlight css colors
vim.keymap.set(
    "n",
    "<leader>css",
    require("nvim-highlight-colors").toggle,
    { silent = true, desc = "Highlight css and color declarations in buffers" }
)

-- Git Fugitive
vim.keymap.set("n", "<leader>g", "<cmd>vert Git<cr>", { desc = "Git Fugitive in vertical window" })

-- Telescope
local builtin = require("telescope.builtin")
require("telescope").setup({
    defaults = {
        wrap_results = true,
        border = true,
        sorting_strategy = "ascending",
    },
})

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files [telescope]" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep live [telescope]" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers [telescope]" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help tags [telescope]" })
vim.keymap.set("n", "<leader>fH", function()
    builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end, { desc = "Find Hidden files [telescope]" })
vim.keymap.set("n", "<leader>f?", builtin.keymaps, { desc = "Find Keymaps [telescope]" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics [telescope]" })

vim.keymap.set("n", "<leader>O", function()
    vim.cmd([[silent %! prettierd %]])
end, { desc = "Format with prettierd [prettierd]" })

-- Harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

vim.keymap.set("n", "<C-a>", function()
    harpoon_mark.add_file()
end, { desc = "Add File [Harpoon]" })

vim.keymap.set("n", "<C-p>", function()
    harpoon_ui.nav_prev()
end, { desc = "Next File [Harpoon]" })

vim.keymap.set("n", "<C-m>", function()
    harpoon_ui.toggle_quick_menu()
end, { desc = "Toggle Quick Menu [Harpoon]" })

vim.keymap.set("n", "<C-n>", function()
    harpoon_ui.nav_next()
end)

-- Set mappings for 0-10
for int = 0, 9 do
    vim.keymap.set("n", tostring(int), function()
        harpoon_ui.nav_file(int)
    end)
end
