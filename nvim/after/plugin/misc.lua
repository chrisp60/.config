---@diagnostic disable-next-line: undefined-global
local set = vim.keymap.set

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
telescope.setup()
telescope.load_extension('git_worktree')

require("harpoon").setup({
    global_settings = {
        mark_branch = true,
        save_on_change = true,
        save_on_toggle = true,
        tabline = false,
    }
})

-- Telescope
set('n', '<leader>G', builtin.live_grep)
set('n', '<leader>h', builtin.help_tags)
set('n', '<leader>b', builtin.git_branches)
set('n', '<leader>c', builtin.git_commits)
set('n', '<leader>R', builtin.lsp_references)
set('n', '<leader>f', builtin.find_files)
set('n', '<leader>"', builtin.registers)
set('n', '<leader>s', builtin.lsp_workspace_symbols)
set('n', '<leader>d', builtin.diagnostics)
set('n', '<leader>C', builtin.commands)

-- Harpoon
set('n', '<leader>F', function() harpoon_mark.add_file() end)
set('n', '<leader>j', function() harpoon_ui.nav_file(1) end)
set('n', '<leader>k', function() harpoon_ui.nav_file(2) end)
set('n', '<leader>l', function() harpoon_ui.nav_file(3) end)
set('n', '<leader>;', function() harpoon_ui.nav_file(4) end)
set('n', '<leader>n', function() harpoon_ui.nav_next() end)
set('n', '<leader>p', function() harpoon_ui.nav_prev() end)
set('n', '<leader>m', function() harpoon_ui.toggle_quick_menu() end)

-- Misc
set('n', '<leader>g', '<cmd>vertical rightbelow G<CR>')
set('n', '<leader>u', vim.cmd.UndotreeToggle) ---@diagnostic disable-line: undefined-global
vim.g.undotree_WindowLayout = 3 ---@diagnostic disable-line: undefined-global
vim.g.undotree_ShortIndicators = 1 ---@diagnostic disable-line: undefined-global
