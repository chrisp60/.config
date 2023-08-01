---@diagnostic disable: trailing-space
---@diagnostic disable: undefined-global

local lsp = require("lsp-zero")
lsp.preset({ name = "minimal" })
lsp.format_on_save({
    format_opts = { async = true, timeout_ms = 10000, },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['rust_analyzer'] = { 'rust' },
        ['null-ls'] = { 'markdown' },
        ['taplo'] = { 'toml' },
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
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gn', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', 'gp', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ 'n', 'v', 'x' }, 'ga', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set({ 'n', 'v', 'x' }, '<leader>h', function() vim.lsp.buf.format({ async = true }) end, opts)
end)

vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    underline = false,
    signs = false,
    float = false,
})

local builtin = require('telescope.builtin')
require('telescope').setup({})

vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>H', builtin.help_tags, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>R', builtin.registers, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, {})

-- Plain lines and minimal flair, please.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { title = nil, border = nil })

require 'nvim-treesitter.configs'.setup {
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("harpoon").setup({ menu = { width = vim.api.nvim_win_get_width(0) - 4, } })
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)
vim.keymap.set('n', 'gj', function() ui.nav_file(1) end)
vim.keymap.set('n', 'gk', function() ui.nav_file(2) end)
vim.keymap.set('n', 'gl', function() ui.nav_file(3) end)
vim.keymap.set('n', 'gh', function() ui.nav_file(4) end)

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd,
    },
})
