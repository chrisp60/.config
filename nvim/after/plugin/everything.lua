---@diagnostic disable: undefined-global

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

require('colorizer').setup()
vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    underline = false,
    signs = false,
    float = false,
})

local lsp = require("lsp-zero")
lsp.preset({ name = "minimal" })
lsp.format_on_save({
    format_opts = { async = false, timeout_ms = 10000, },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['rust_analyzer'] = { 'rust' },
        ['null-ls'] = { 'markdown', 'html', 'htmldjango', 'md' },
        ['taplo'] = { 'toml' },
        ['tsserver'] = { 'typescript' },
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Insert }
local cmp_mappings = lsp.defaults.cmp_mappings({
    -- Only show the good stuff
    ['<C-t>'] = cmp.mapping.complete({ config = {
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' }
        }
    } }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
})

lsp.setup_nvim_cmp({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    preselect = 'none',
    completion = { completeopt = 'menu,menuone,noselectpreview' },
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', },
        { name = 'buffer' },
        { name = 'path' },
    },
    experimental = { ghost_text = true },
})

lsp.setup()

lsp.on_attach(function(client, bufnr)
    -- client.server_capabilities.semanticTokensProvider = nil
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { desc = "hover [LSP]" })
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { desc = "go to definition [LSP]" })
    vim.keymap.set('n', 'gn', function() vim.diagnostic.goto_next() end, { desc = "go to next diagnostic [LSP]" })
    vim.keymap.set('n', 'gp', function() vim.diagnostic.goto_prev() end, { desc = "go to prev diagnostic [LSP]" })
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, { desc = "rename [LSP]" })
    vim.keymap.set({ 'n', 'v', 'x' }, 'ga', function() vim.lsp.buf.code_action() end, { desc = "code action [LSP]" })
    vim.keymap.set({ 'n', 'v', 'x' }, '<leader>h', function() vim.lsp.buf.format({ async = false }) end,
        { desc = "format using all [LSP]" })
    vim.keymap.set({ 'n', 'v', 'x' }, '<leader>o', "<cmd>w % | silent !leptosfmt % -t 2<CR>",
        { desc = "leptosfmt current buffer [LSP]" })
end)



local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup()
telescope.load_extension('git_worktree')
vim.keymap.set('n', '<leader>Gw', function() telescope.extensions.git_worktree.git_worktrees() end, { -- @map telescope
    desc = "list worktree [git-worktree]"
})
vim.keymap.set('n', '<leader>Ga', function() telescope.extensions.git_worktree.create_git_worktree() end,
    {
        desc = "create worktree [git-worktree]"
    })


vim.keymap.set('n', '<leader>c', builtin.commands, { desc = "commands [telescope]" })                           -- @map telescope
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "live grep [telescope]" })                         -- @map telescope
vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = "help tags [telescope]" })                         -- @map telescope
vim.keymap.set('n', '<leader>Gb', builtin.git_branches, { desc = "git branches [telescope]" })                  -- @map telescope
vim.keymap.set('n', '<leader>Gc', builtin.git_commits, { desc = "git commits [telescope]" })                    -- @map telescope
vim.keymap.set('n', '<leader>S', builtin.lsp_references, { desc = "lsp references [telescope]" })               -- @map telescope
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "find files [telescope]" })                       -- @map telescope
vim.keymap.set('n', '<leader>R', builtin.registers, { desc = "registers [telescope]" })                         -- @map telescope
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, { desc = "lsp workspace symbols [telescope]" }) -- @map telescope


vim.keymap.set('n', '<leader>GG', '<cmd>vertical rightbelow G<CR>', { desc = "git status, vertical [fugitive]" }) -- @map fugitive
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "toggle [undotree]" })                          -- @map undotree

vim.keymap.set('n', '<leader>x', '<cmd>Neorg toggle-concealer<CR>', {})                                           -- @map neorg

vim.g.undotree_WindowLayout = 3                                                                                   -- @g undotree
vim.g.undotree_ShortIndicators = 1                                                                                -- @g undotree

local harpoon = require('harpoon')
local harpoon_ui = require('harpoon.ui')
local harpoon_mark = require('harpoon.mark')
harpoon.setup({ menu = { width = vim.api.nvim_win_get_width(0) - 4, } })                                  -- @opts harpoon
vim.keymap.set('n', 'gA', function() harpoon_mark.add_file() end, { desc = "add file [harpoon]" })        -- @map harpoon
vim.keymap.set('n', 'gm', function() harpoon.toggle_quick_menu() end, { desc = "toggle menu [harpoon]" }) -- @map harpoon
vim.keymap.set('n', 'gj', function() harpoon_ui.nav_file(1) end, { desc = "file 1 [harpoon]" })           -- @map harpoon
vim.keymap.set('n', 'gk', function() harpoon_ui.nav_file(2) end, { desc = "file 2 [harpoon]" })           -- @map harpoon
vim.keymap.set('n', 'gl', function() harpoon_ui.nav_file(3) end, { desc = "file 3 [harpoon]" })           -- @map harpoon
vim.keymap.set('n', 'gh', function() harpoon_ui.nav_file(4) end, { desc = "file 4 [harpoon]" })           -- @map harpoon

-- !TODO: change this when fixed. See https://github.com/nvim-telescope/telescope.nvim/issues/2661
vim.keymap.set('n', '<leader>d', '<cmd>Telescope diagnostics severity_bound=ERROR<CR>', {
    desc = "'<cmd>Telescope diagnostics severity_bound=ERROR<CR>'"
})

--[[
    --Plain lines and minimal flair, please.
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { title = nil, border = nil })
]]
