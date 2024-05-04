Set = vim.keymap.set 
O = vim.opt

vim.g.mapleader = ' '

O.number = true
O.relativenumber = true
O.showcmd = true
O.showmode = false
O.wrap = false
O.signcolumn = "yes"
O.textwidth = 100
O.cursorline = true
O.colorcolumn = "100"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- init.lua:
	{
		'nvim-telescope/telescope.nvim', 
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function() 
			require('telescope').setup()
			local tele = require('telescope.builtin')
			Set("n", "<leader>f", tele.find_files)
			Set("n", "<leader>h", tele.help)
		end,
	},

	{ "folke/neodev.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-fugitive", keys = { {"n", "<leader>t", "<cmd>Git<cr>" } } },

})
