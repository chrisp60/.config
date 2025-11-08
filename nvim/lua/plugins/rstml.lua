return {
	{
		"rayliwell/tree-sitter-rstml",
		dependencies = { "nvim-treesitter" },
		build = ":TSUpdate",
		config = function()
			require("tree-sitter-rstml").setup()
		end,
	},
	-- Automatic tag closing and renaming (optional but highly recommended)
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
