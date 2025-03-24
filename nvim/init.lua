---@diagnostic disable-next-line: inject-field
vim.g.mapleader = " "
vim.opt.conceallevel = 0

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
vim.opt.autoindent = false
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wrap = false

vim.diagnostic.config({
	virtual_text = { severity = "ERROR" },
	update_in_insert = true,
	signs = false,
	underline = false,
})

-- util keymap for inlined rinja templates.
vim.keymap.set(
	{ "v" },
	"<leader>z",
	[[:'<,'>.! sqlfluff format --dialect postgres - <cr>]],
	{ desc = "Format sql block", silent = true }
)

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.html" },
	callback = function()
		vim.cmd([[set ft=htmldjango]])
	end,
})

vim.api.nvim_create_user_command("Virt", function(opts)
	local level = string.upper(opts.fargs[1])
	vim.print("setting level to " .. level)
	vim.diagnostic.config({ virtual_text = { severity = parsed } })
	vim.diagnostic.reset()
	vim.diagnostic.show()
end, {
	nargs = 1,
	complete = function(_)
		return { "hint", "info", "warn", "error" }
	end,
})
