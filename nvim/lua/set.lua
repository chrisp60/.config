vim.keymap.set('n', ']]', ':cn<CR>', {})
vim.keymap.set('n', '[[', ':cp<CR>', {})
vim.keymap.set('n', '<leader>k', ':copen<CR>', {})
vim.g.mapleader = ' '
vim.opt.path:append '**'
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80,100"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.updatetime = 10
