local telescope = require('telescope')
local builtin = require('telescope.builtin')
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

telescope.setup()

require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
    global_settings = {
        mark_branch = true,
        save_on_change = true,
        save_on_toggle = true,
        tabline = false,
    }
})

local function find_hidden()
    builtin.find_files({
        hidden = true,
        no_ignore = false,
        no_ignore_parent = false
    })
end


-- Telescope
vim.keymap.set('n', '<leader>"', builtin.registers, { desc = 'registers [Telescope]' })
vim.keymap.set('n', '<leader>C', builtin.commands, { desc = 'commands [Telescope]' })
vim.keymap.set('n', '<leader>G', builtin.live_grep, { desc = 'live grep [Telescope]' })
vim.keymap.set('n', '<leader>b', builtin.git_branches, { desc = 'git branches [Telescope]' })
vim.keymap.set('n', '<leader>c', builtin.git_commits, { desc = 'git commits [Telescope]' })
vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'diagnostics [Telescope]' })
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'find files [Telescope]' })
vim.keymap.set('n', '<leader>H', find_hidden, { desc = 'find files [Telescope]' })
vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'help tags [Telescope]' })
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, { desc = 'lsp workspace symbols [Telescope]' })
vim.keymap.set('n', '<leader>R', builtin.lsp_references, { desc = 'lsp references [Telescope]' })

-- Harpoon
vim.keymap.set('n', '<leader>F', function() harpoon_mark.add_file() end, { desc = 'add_file() [Harpoon]' })
vim.keymap.set('n', '<leader>j', function() harpoon_ui.nav_file(1) end, { desc = 'nav_file(1) [Harpoon]' })
vim.keymap.set('n', '<leader>k', function() harpoon_ui.nav_file(2) end, { desc = 'nav_file(2) [Harpoon]' })
vim.keymap.set('n', '<leader>l', function() harpoon_ui.nav_file(3) end, { desc = 'nav_file(3) [Harpoon]' })
vim.keymap.set('n', '<leader>;', function() harpoon_ui.nav_file(4) end, { desc = 'nav_file(4) [Harpoon]' })
vim.keymap.set('n', '<leader>n', function() harpoon_ui.nav_next() end, { desc = 'nav_next() [Harpoon]' })
vim.keymap.set('n', '<leader>p', function() harpoon_ui.nav_prev() end, { desc = 'nav_prev() [Harpoon]' })
vim.keymap.set('n', '<leader>m', function() harpoon_ui.toggle_quick_menu() end,
    { desc = 'toggle_quick_menu() [Harpoon]' })

-- Misc
vim.keymap.set('n', '<leader>g', '<cmd>vertical rightbelow G<CR>')
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [UndoTree]' })

vim.g.undotree_WindowLayout = 3 ---@diagnostic disable-line: undefined-global
vim.g.undotree_ShortIndicators = 1 ---@diagnostic disable-line: undefined-global
