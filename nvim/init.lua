vim.lsp.set_log_level("ERROR")
vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.path:append("**")
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 10
vim.opt.wrap = false

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
require("lazy").setup({
	--- Uncomment these if you want to manage LSP servers from neovim
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "github/copilot.vim" },

	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip", lazy = false },
	{ "saadparwaiz1/cmp_luasnip", lazy = false },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				auto_install = true,
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		init = function()
			require("ibl").setup({
				scope = {
					enabled = true,
					char = "╎",
					show_start = true,
				},
				indent = { char = "╎" },
			})
		end,
	},

	{ "folke/neodev.nvim" },
	{ "brenoprata10/nvim-highlight-colors" },
	{ "theprimeagen/harpoon" },
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-surround" },
	{ "wesleimp/stylua.nvim" },
	{ "christoomey/vim-tmux-navigator" },
	{ "lukas-reineke/lsp-format.nvim" },
	{ "wesleimp/stylua.nvim" },
})

-- *********************************
-- Plugin Config
-- *********************************

-- Load colorscheme
vim.cmd.colorscheme("catppuccin")

-- LSP config stolen directly from
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md#primes-config

local lsp_zero = require("lsp-zero")

---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
	local function opts_desc(desc)
		return { buffer = bufnr, remap = false, desc = desc }
	end

	if vim.bo.filetype == "lua" then
		vim.cmd([[autocmd BufWritePre *.lua lua require("stylua").format()]])
	else
		lsp_zero.buffer_autoformat()
	end

	vim.keymap.set("n", "<leader>o", function()
		vim.cmd([[silent ! leptosfmt % -t 2 -m 75]])
	end)

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts_desc("Go to Definition [LSP]"))

	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts_desc("Show hover [LSP]"))

	-- Telescope
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>s", function()
		builtin.lsp_dynamic_workspace_symbols()
	end, opts_desc("Workspace Symbol [LSP]"))

	vim.keymap.set("n", "<leader>S", function()
		builtin.lsp_document_symbols()
	end, opts_desc("Workspace Symbol [LSP]"))

	vim.keymap.set("n", "<leader>R", function()
		builtin.lsp_references()
	end, opts_desc("References [LSP]"))
	-- Telescope

	vim.keymap.set("n", "gn", function()
		vim.diagnostic.goto_next()
	end, opts_desc("Next Diagnostic [LSP]"))

	vim.keymap.set("n", "gp", function()
		vim.diagnostic.goto_prev()
	end, opts_desc("Previous Diagnostic [LSP]"))

	vim.keymap.set({ "n", "v", "x" }, "ga", function()
		vim.lsp.buf.code_action()
	end, opts_desc("Code Action [LSP]"))

	vim.keymap.set("n", "<leader>r", function()
		vim.lsp.buf.rename()
	end, opts_desc("Rename All [LSP]"))

	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts_desc("Signature Help [LSP]"))
end)

vim.diagnostic.config({ virtual_text = true, underline = false })

-- Mason & LSP
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "cssls", "taplo", "lua_ls" },
	handlers = {
		lsp_zero.default_setup,

		lua_ls = function()
			require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls({}))
		end,

		rust_analyzer = function()
			require("lspconfig")["rust_analyzer"].setup({
				settings = {
					["rust-analyzer"] = {
						cargo = { features = "all" },
						completion = {
							fullFunctionSignatures = {
								enable = true,
							},
						},
						check = {
							features = "all",
							ignore = { "inactive-code", "unlinked-file" },
							command = "clippy",
						},
					},
				},
			})
		end,
	},
})

-- nvim cmp
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body, {
				indent = false,
			})
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
	},
	mapping = cmp.mapping.preset.insert({
		-- select cmp options
		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-l>"] = cmp.mapping.confirm({ select = true }),

		-- luasnip movements
		["<C-n>"] = cmp_action.luasnip_jump_forward(),
		["<C-p>"] = cmp_action.luasnip_jump_backward(),

		-- Invoke cmp menu manually
		["<C-t>"] = cmp.mapping.complete(),
	}),
	formatting = require("lsp-zero").cmp_format(),
})

-- Highlight css colors
vim.keymap.set(
	"n",
	"<leader>css",
	require("nvim-highlight-colors").toggle,
	{ silent = true, desc = "Highlight css and color declarations in buffers" }
)

-- Git Fugitive
vim.keymap.set("n", "<leader>G", "<cmd>vert Git<cr>", { desc = "Git Fugitive in vertical window" })

-- Telescope
local builtin = require("telescope.builtin")
require("telescope").setup({
	defaults = {
		wrap_results = true,
		border = true,
		sorting_strategy = "ascending",
	},
})

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find Files [telescope]" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Grep live [telescope]" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find buffers [telescope]" })
vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "Find Help tags [telescope]" })
vim.keymap.set("n", "<leader>H", function()
	builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end, { desc = "Find Hidden files [telescope]" })
vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Find Keymaps [telescope]" })

vim.keymap.set("n", "<leader>O", function()
	vim.cmd([[silent %! prettierd %]])
end, { desc = "Format with prettierd [prettierd]" })

-- Harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

vim.keymap.set("n", "gA", function()
	harpoon_mark.add_file()
end, { desc = "Add File [Harpoon]" })

vim.keymap.set("n", "<C-p>", function()
	harpoon_ui.nav_prev()
end, { desc = "Next File [Harpoon]" })

vim.keymap.set("n", "gm", function()
	harpoon_ui.toggle_quick_menu()
end, { desc = "Toggle Quick Menu [Harpoon]", remap = false, silent = false })

vim.keymap.set("n", "<C-n>", function()
	harpoon_ui.nav_next()
end)

-- Set mappings for 0-10
for int = 0, 9 do
	vim.keymap.set("n", tostring(int), function()
		harpoon_ui.nav_file(int)
	end, { desc = "Go to " .. tostring(int) .. " Harpoon file [Harpoon]" })
end

-- Trouble

local trouble = require("trouble")

trouble.setup({
	position = "right",
	icons = false,
	width = 80,
	mode = "workspace_diagnostics",
	fold_open = "v",
	fold_closed = ">",
	win_config = { border = "none" },
	multiline = true,
	indent_lines = false,
	auto_open = false,
	auto_close = false,
	auto_preview = false,
	auto_fold = true,
	auto_jump = { "lsp_definitions" },
	include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" },
	use_diagnostic_signs = true,
})

vim.keymap.set("n", "<leader>dt", function()
	trouble.toggle()
end)
vim.keymap.set("n", "<leader>dw", function()
	trouble.toggle("workspace_diagnostics")
end)
vim.keymap.set("n", "<leader>db", function()
	trouble.toggle("document_diagnostics")
end)
vim.keymap.set("n", "gR", function()
	require("trouble").toggle("lsp_references")
end)

-- Copilot
vim.keymap.set("i", "<C-F>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-D>", 'copilot#Accept("<CR>")', {
	expr = true,
	replace_keycodes = false,
})

---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("all", {
	s(
		"#[component]",
		fmt(
			[[
            #[component{transparent}]
            {vis}fn {name}({args}) -> impl IntoView {{ 
                todo!() 
            }}
            ]],
			{
				name = i(1, "name"),
				args = i(2, "args"),
				vis = c(3, {
					t("pub "),
					t(""),
				}),
				transparent = c(4, {
					t("(transparent)"),
					t(""),
				}),
			}
		)
	),
	s(
		"#[server]",
		fmt(
			[[
            #[server]
            {vis}async fn {name}({args}) -> Result<{ret}, ServerFnError> {{ 
                todo!() 
            }}
            ]],
			{
				name = i(1, "name"),
				ret = i(2, "()"),
				args = i(3, "args"),
				vis = c(4, {
					t("pub "),
					t(""),
				}),
			}
		)
	),
})
