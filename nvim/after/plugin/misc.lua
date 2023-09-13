---@diagnostic disable-next-line: undefined-global
local set = vim.keymap.set

require('gitsigns').setup()

local gitsigns = require('gitsigns')
local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup()
telescope.load_extension('git_worktree')
set('n', '<leader>gn', gitsigns.next_hunk, { desc = "next hunk [gitsigns]" })
set('n', '<leader>gp', gitsigns.prev_hunk, { desc = "prev hunk [gitsigns]" })
set('n', '<leader>Gw', telescope.extensions.git_worktree.git_worktrees)
set('n', '<leader>Ga', telescope.extensions.git_worktree.create_git_worktree)
set('n', '<leader>c', function() print("hello") end)
set('n', '<leader>g', builtin.live_grep)
set('n', '<leader>H', builtin.help_tags)
set('n', '<leader>Gb', builtin.git_branches)
set('n', '<leader>Gc', builtin.git_commits)
set('n', '<leader>S', builtin.lsp_references)
set('n', '<leader>f', builtin.find_files)
set('n', '<leader>R', builtin.registers)
set('n', '<leader>s', builtin.lsp_workspace_symbols)
set('n', '<leader>s', builtin.diagnostics)
set('n', '<leader>GG', '<cmd>vertical rightbelow G<CR>')
set('n', '<leader>x', '<cmd>Neorg toggle-concealer<CR>')

set('n', '<leader>u', vim.cmd.UndotreeToggle) ---@diagnostic disable-line: undefined-global
vim.g.undotree_WindowLayout = 3 ---@diagnostic disable-line: undefined-global
vim.g.undotree_ShortIndicators = 1 ---@diagnostic disable-line: undefined-global
