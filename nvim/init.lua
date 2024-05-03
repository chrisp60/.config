-- Update with nightly release: sudo update.sh

-- Leader keys must come before plugins
vim.g.mapleader = " "
-- vim.g.lsp_zero_extend_cmp = 0

local util = require("util")

vim.lsp.set_log_level("ERROR")
vim.opt.undofile = true
vim.opt.colorcolumn = "80,100"
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
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Do not show hot-reload messages from Lazy
require("lazy").setup("plugins", {

    dev = {
        path = "~/projects",
        patterns = { "chrisp60" },
        fallback = false,
    },
    change_detection = {
        notify = false,
    },
})

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    signs = false,
    underline = false,
})

util.normal_leader("L", "<cmd>luafile %<cr>", "run the buffer as lua")

vim.keymap.set("n", "<C-c>n", "<cmd>cn<cr>")
vim.keymap.set("n", "<C-c>p", "<cmd>cp<cr>")
vim.keymap.set("n", "<C-c>o", "<cmd>cope<cr>")

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    pattern = "*.html",
    callback = function()
        vim.cmd([[set ft=htmldjango]])
        util.normal_leader("e", function()
            vim.cmd([[silent !djlint % --quiet --reformat]])
            vim.cmd([[edit]])
            vim.cmd([[set ft=htmldjango]])
        end)
    end,
})
