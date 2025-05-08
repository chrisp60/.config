local set = vim.keymap.set
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = {
					save_on_toggle = true,
				},
			})

			local function desc(text)
				return { desc = "Harpoon: " .. text }
			end

			set("n", "sa", function()
				harpoon:list():add()
			end, desc("add"))
			set("n", "sm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, desc("toggle menu"))
			set("n", "sj", function()
				harpoon:list():select(1)
			end, desc("select first"))
			set("n", "sk", function()
				harpoon:list():select(2)
			end, desc("select second"))
			set("n", "sl", function()
				harpoon:list():select(3)
			end, desc("select third"))
			set("n", "s;", function()
				harpoon:list():select(4)
			end, desc("select fourth"))
		end,
	},
}
