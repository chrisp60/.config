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

local function inspect_token()
    local token = vim.lsp.semantic_tokens.get_at_pos()[1]
    local captures = vim.treesitter.get_captures_at_cursor()
    local LEVEL = vim.log.levels.INFO
    local msg = vim.inspect({
        type = token.type,
        modifiers = token.modifiers,
        ts_captures = captures,
    })
    vim.notify(msg, LEVEL)
end


vim.keymap.set("n", "<leader>e", inspect_token)
vim.keymap.set("n", "<leader>i", "<cmd>:TSToggle highlight<cr>")



vim.keymap.set("n", "<leader>q", function()
    vim.diagnostic.config({ virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } }, })
    vim.notify("Set diganostics to ERROR", vim.log.levels.INFO)
end)
vim.keymap.set("n", "<leader>Q", function()
    vim.diagnostic.config({ virtual_text = { severity = { min = vim.diagnostic.severity.WARN } }, })
    vim.notify("Set diganostics to WARN", vim.log.levels.INFO)
end)


vim.diagnostic.config({
    virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
    underline = false,
    update_in_insert = true,
    signs = false,
})
