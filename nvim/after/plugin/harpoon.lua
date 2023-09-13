local harpoon = require('harpoon')
local harpoon_ui = require('harpoon.ui')
local harpoon_mark = require('harpoon.mark')
local set = vim.keymap.set
harpoon.setup()
set('n', 'gA', function() harpoon_mark.add_file() end)
set('n', 'gm', function() harpoon_ui.toggle_quick_menu() end)
set('n', 'gj', function() harpoon_ui.nav_file(1) end)
set('n', 'gk', function() harpoon_ui.nav_file(2) end)
set('n', 'gl', function() harpoon_ui.nav_file(3) end)
set('n', 'gh', function() harpoon_ui.nav_file(4) end)

