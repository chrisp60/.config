local utils = require("util")
require("lsp-format").setup({})

local prettier_ft = {}
prettier_ft["css"] = {}
prettier_ft["html"] = {}
prettier_ft["json"] = {}
prettier_ft["json-stringify"] = {}
prettier_ft["json5"] = {}
prettier_ft["markdown"] = {}
prettier_ft["scss"] = {}
prettier_ft["typescript"] = {}
prettier_ft["yaml"] = {}

local handle_formatting = function()
	local filetype = vim.filetype.match({ buf = 0 })

	for supp_prettier, _ in pairs(prettier_ft) do
		if filetype == supp_prettier then
			vim.cmd.write()
			local command = "%! npx prettier --parser " .. supp_prettier
			vim.cmd(command)
			vim.notify("using prettier" .. supp_prettier, vim.log.levels.INFO)
			return
		end
	end

	local filetype = vim.filetype.match({ buf = 0 })
	if filetype == "rust" and utils.buf_has_str(0, "leptos") then
		vim.cmd.write()
		vim.cmd([[silent !leptosfmt % -t 2]])
		vim.notify("using leptos", vim.log.levels.INFO)
	elseif filetype == "lua" then
		require("stylua").format()
	else
		vim.lsp.buf.format()
	end
end

local on_attach = function(client, bufnr)
	-- LuaLs default formatter kind of really sucks.
	vim.keymap.set("n", "<leader>o", handle_formatting)

	vim.keymap.set("n", "K", vim.lsp.buf.hover)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<C-p>", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
	vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action)

	-- https://github.com/lukas-reineke/lsp-format.nvim#wq-will-not-format-when-not-using-sync
	vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])
	require("lsp-format").on_attach(client, bufnr)

	-- Reduce noise from lsp diagnostics
	vim.diagnostic.config({
		update_in_insert = true,
		-- Virtual text should only include ERROR level diagnostics
		virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
		signs = true,
		float = true,
		underline = false,
	})
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
mason.setup({})
mason_lspconfig.setup({})
mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
	end,
	["rust_analyzer"] = function()
		require("lspconfig")["rust_analyzer"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = {
							group = "crate",
							enforce = true,
						},
						group = {
							enable = true,
						},
						merge = {
							glob = false,
						},
						prefix = "crate",
					},
					interpret = {
						tests = true,
					},
					cargo = {
						buildScripts = {
							enable = true,
						},
						features = "all",
					},
					check = {
						command = "clippy",
					},
					completion = {
						callable = {
							snippets = "fill_arguments",
						},
						postfix = {
							enable = true,
						},
					},
					references = {
						excludeImports = {
							enable = true,
						},
					},
					hover = {
						actions = {
							enable = true,
							run = {
								enable = true,
							},
							debug = {
								enable = true,
							},
						},
						links = {
							enable = true,
						},
						memoryLayout = {
							size = "both",
							enable = true,
							niches = true,
						},
					},
					diagnostics = {
						disabled = { "inactive-code" },
						experimental = {
							enable = true,
						},
					},
					procMacro = {
						ignored = {
							leptos_macro = {
								"component",
							},
						},
						enable = true,
						attributes = {
							enable = true,
						},
					},
					semanticHighlighting = {
						punctuation = {
							enable = true,
							separate = {
								macro = {
									bang = true,
								},
							},
						},
					},
				},
			},
		})
	end,
})
