---@diagnostic disable-next-line: inject-field
vim.g.mapleader = " "

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

require("lazy").setup("plugins", {
	rocks = { enabled = false },
	change_detection = {
		notify = false,
	},
})

local o = vim.opt
vim.lsp.log.set_level(vim.log.levels.ERROR)
vim.g.clipboard = "tmux"
o.autoindent = true
o.smartcase = true
o.ignorecase = true
o.conceallevel = 0
o.colorcolumn = "80,100"
o.cursorline = true
o.expandtab = true
o.hlsearch = false
o.incsearch = true
o.nu = true
o.relativenumber = true
o.shiftwidth = 4
o.showmode = true
o.signcolumn = "yes"
o.smartindent = true
o.softtabstop = 4
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.undofile = true
o.wrap = false

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
	signs = false,
	underline = false,
})

vim.keymap.set(
	{ "v" },
	"<leader>z",
	[[:'<,'>.! sqlfluff format --dialect postgres - <cr>]],
	{ desc = "Format sql block", silent = true }
)

vim.api.nvim_create_autocmd("BufEnter", { command = "set conceallevel=0" })
