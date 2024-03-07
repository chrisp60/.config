-- Reinstalling neovim
-- https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2
-- -----------------------------------------------------------------------
-- curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
-- sudo rm -rf /opt/nvim
-- sudo tar -C /opt -xzf nvim-linux64.tar.gz
--
-- add to .zshrc
-- export PATH="$PATH:/opt/nvim/"

vim.g.mapleader = " "

-- Lsp clients are noisy
vim.lsp.set_log_level("ERROR")

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

local catppuccin_flavor = function()
    local flavor = os.getenv("CATPPUCCIN_FLAVOUR") or "mocha"
    return "catppuccin-" .. flavor
end

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

local lazy_opts = {
    change_detection = {
        notify = false,
    },
}

require("lazy").setup("plugins", lazy_opts)

vim.cmd.colorscheme(catppuccin_flavor())

vim.keymap.set("n", "<leader>i", "<cmd>:TSToggle highlight<cr>")

-- I like to dynamically change diagnostic levels depending on what is being
-- done. i.e. refactoring is just ERRORs, implementing includes WARN.
local ERROR = vim.diagnostic.severity.ERROR
local WARN = vim.diagnostic.severity.WARN

-- Update severity for virtual text and keymaps.
local function update_diagnostic_mapping(level)
    local min = { severity = { min = level } }
    vim.diagnostic.config({
        virtual_text = min,
        update_in_insert = true,
        signs = false,
        underline = false,
    })
    vim.keymap.set("n", "gn", function()
        vim.diagnostic.goto_next(min)
    end)
    vim.keymap.set("n", "gp", function()
        vim.diagnostic.goto_prev(min)
    end)
    vim.notify("Diagnostics set to " .. level, 1)
end

update_diagnostic_mapping(ERROR)

vim.keymap.set("n", "<leader>q", function()
    update_diagnostic_mapping(ERROR)
end)
vim.keymap.set("n", "<leader>Q", function()
    update_diagnostic_mapping(WARN)
end)
