vim.g.mapleader = " "
vim.opt.conceallevel = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line:undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },

			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

vim.lsp.set_log_level("ERROR")
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
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wrap = false

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = false,
	signs = false,
	underline = false,
})

-- Do not show hot-reload messages from Lazy
require("lazy").setup("plugins", {
	rocks = { enabled = false },
	ui = {
		icons = {
			cmd = " ",
			config = " ",
			event = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = " ",
			loaded = " ",
			not_loaded = " ",
			plugin = " ",
			runtime = " ",
			require = " ",
			source = " ",
			start = " ",
			task = " ",
			list = { "- " },
		},
	},
	change_detection = {
		notify = false,
	},
})

vim.keymap.set({ "n", "v", "x" }, "<leader>yy", '"+y', { desc = "system yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>yd", '"_d', { desc = "blackhole delete" })

-- == Rinja Stuff ==

-- util keymap for inlined rinja templates.
vim.keymap.set(
	{ "v" },
	"<leader>z",
	[[:'<,'>.! prettier-pnp --quiet --pn=jinja-template --parser jinja-template --single-attribute-per-line true --stdin-filepath %<cr>]],
	{ desc = "Format rinja block", silent = true }
)

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.html" },
	callback = function()
		vim.cmd([[set ft=htmldjango]])
	end,
})
