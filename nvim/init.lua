-- Update with nightly release: sudo update.sh

-- Leader keys must come before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "_"
vim.g.lsp_zero_extend_cmp = 0
vim.g.lsp_zero_ui_float_border = "none"

vim.lsp.set_log_level("ERROR") -- Lsp clients are noisy
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
