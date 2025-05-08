---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
		---@module 'catppuccin'
		---@type CatppuccinOptions
		opts = {
			no_italic = true,
			integrations = {
				fidget = true,
				native_lsp = {
					enabled = true,
				},
				mason = true,
				harpoon = true,
				indent_blankline = {
					enabled = true,
					scope_color = "rosewater",
					colored_indent_levels = true,
				},
			},
			highlight_overrides = {
				all = function(colors)
					return {
						LineNr = { fg = colors.maroon },
					}
				end,
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			---@type ibl.config
			opts = {
				enabled = true,
				scope = {
					enabled = true,
					show_start = true,
				},
			}
			require("ibl").setup(opts)
		end,
	},

	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				start_mode = "normal",
				border = "single",
			},
		},
	},
}
