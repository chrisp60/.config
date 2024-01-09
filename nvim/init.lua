vim.g.mapleader = " "

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorcolumn = false
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
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
require("lazy").setup("plugins")


local flavor = os.getenv("CATPPUCCIN_FLAVOUR") or "mocha"
vim.cmd.colorscheme("catppuccin-" .. flavor)

vim.diagnostic.config({
    virtual_text = true,
    underline = false,
    update_in_insert = true,
    signs = false,
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
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "luasnip" },
        { name = "nvim_lua" },
    },
    mapping = cmp.mapping.preset.insert({
        -- select cmp options
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = require("lsp-zero").cmp_format(),
    experimental = { ghost_text = false, },
})

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>g", builtin.live_grep)
vim.keymap.set("n", "<leader>b", builtin.buffers)
vim.keymap.set("n", "<leader>h", builtin.help_tags)
vim.keymap.set("n", "<leader>H", function()
    builtin.find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
    })
end)
vim.keymap.set("n", "<leader>?", builtin.keymaps)
