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

---@param level integer|nil One of the values from |vim.log.levels|.
local function set_severity(level)
    vim.diagnostic.config({
        virtual_text = { severity = { min = level } },
    })
    vim.keymap.set('n', "<leader>n", function()
        vim.diagnostic.goto_next({ severity = { min = level } })
    end)
    vim.keymap.set('n', "<leader>p", function()
        vim.diagnostic.goto_prev({ severity = { min = level } })
    end)
    vim.notify("Diagnostics set to " .. level, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>q", function() set_severity(vim.log.levels.ERROR) end)
vim.keymap.set("n", "<leader>Q", function() set_severity(vim.log.levels.WARN) end)


vim.diagnostic.config({
    virtual_text = true,
    underline = false,
    update_in_insert = true,
    signs = false,
})
