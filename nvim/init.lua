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
    --- Uncomment these if you want to manage LSP servers from neovim
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "github/copilot.vim" },
    { "VonHeikemen/lsp-zero.nvim",        branch = "v3.x" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip",                 lazy = false },
    { "saadparwaiz1/cmp_luasnip",         lazy = false },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                sync_install = false,
                highlight = { enable = true },
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            require("ibl").setup({
                scope = {
                    enabled = true,
                    char = "╎",
                    show_start = true,
                },
                indent = {
                    char = "╎",
                },
            })
        end,
    },

    { "folke/neodev.nvim" },
    { "theprimeagen/harpoon" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-surround" },
    { "wesleimp/stylua.nvim" },
    { "christoomey/vim-tmux-navigator" },
    { "wesleimp/stylua.nvim" },
})

vim.cmd.colorscheme("catppuccin")

-- LSP config stolen directly from
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md#primes-config
if vim.bo.filetype == "lua" then
    vim.cmd([[autocmd BufWritePre *.lua lua require("stylua").format()]])
end

local lsp_zero = require("lsp-zero")
---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
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

vim.diagnostic.config({ virtual_text = true, underline = false })

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
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
    },
    mapping = cmp.mapping.preset.insert({
        -- select cmp options
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
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

local hidden_files = function()
    builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end

vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>g", builtin.live_grep)
vim.keymap.set("n", "<leader>b", builtin.buffers)
vim.keymap.set("n", "<leader>h", builtin.help_tags)
vim.keymap.set("n", "<leader>H", hidden_files)
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
vim.keymap.set("n", "<C-n>", harpoon_ui.nav_next)
vim.keymap.set("n", "<C-p>", harpoon_ui.nav_prev)

-- Copilot
vim.keymap.set("i", "<C-F>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-D>", 'copilot#Accept("<CR>")', {
    expr = true,
    replace_keycodes = false,
})

-- LuaSnip
---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("all", {
    s(
        "#[component]",
        fmt(
            [[
            #[component{transparent}]
            {vis}fn {name}({args}) -> impl IntoView {{
                todo!()
            }}
            ]],
            {
                name = i(1, "name"),
                args = i(2, "args"),
                vis = c(3, {
                    t("pub "),
                    t(""),
                }),
                transparent = c(4, {
                    t("(transparent)"),
                    t(""),
                }),
            }
        )
    ),
    s(
        "#[server]",
        fmt(
            [[
            #[server]
            {vis}async fn {name}({args}) -> Result<{ret}, ServerFnError> {{
                todo!()
            }}
            ]],
            {
                name = i(1, "name"),
                ret = i(2, "()"),
                args = i(3, "args"),
                vis = c(4, {
                    t("pub "),
                    t(""),
                }),
            }
        )
    ),
})
