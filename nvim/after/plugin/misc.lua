local telescope = require('telescope')
local builtin = require('telescope.builtin')
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
local gitsigns = require('gitsigns')

gitsigns.setup()
telescope.setup()

require("harpoon").setup({
    global_settings = {
        mark_branch = true,
        save_on_change = true,
        save_on_toggle = true,
        tabline = false,
    }
})

-- Telescope
vim.keymap.set('n', '<leader>"', builtin.registers)
vim.keymap.set('n', '<leader>C', builtin.commands)
vim.keymap.set('n', '<leader>G', builtin.live_grep)
vim.keymap.set('n', '<leader>b', builtin.git_branches)
vim.keymap.set('n', '<leader>c', builtin.git_commits)
vim.keymap.set('n', '<leader>d', builtin.diagnostics)
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>h', builtin.help_tags)
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols)
vim.keymap.set('n', '<leader>R', builtin.lsp_references)

-- Harpoon
vim.keymap.set('n', '<leader>F', function() harpoon_mark.add_file() end)
vim.keymap.set('n', '<leader>j', function() harpoon_ui.nav_file(1) end)
vim.keymap.set('n', '<leader>k', function() harpoon_ui.nav_file(2) end)
vim.keymap.set('n', '<leader>l', function() harpoon_ui.nav_file(3) end)
vim.keymap.set('n', '<leader>;', function() harpoon_ui.nav_file(4) end)
vim.keymap.set('n', '<leader>n', function() harpoon_ui.nav_next() end)
vim.keymap.set('n', '<leader>p', function() harpoon_ui.nav_prev() end)
vim.keymap.set('n', '<leader>m', function() harpoon_ui.toggle_quick_menu() end)

-- Misc
vim.keymap.set('n', '<leader>g', '<cmd>vertical rightbelow G<CR>')
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>gn', gitsigns.next_hunk)
vim.keymap.set('n', '<leader>gp', gitsigns.prev_hunk)

vim.g.undotree_WindowLayout = 3 ---@diagnostic disable-line: undefined-global
vim.g.undotree_ShortIndicators = 1 ---@diagnostic disable-line: undefined-global
