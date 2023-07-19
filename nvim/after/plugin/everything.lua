---@diagnostic disable: trailing-space
---@diagnostic disable: undefined-global

local lsp = require("lsp-zero")
lsp.preset({
    name = "minimal",
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
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
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
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'luasnip',  group_index = 2 },
        { name = 'buffer',   keyword_length = 3, group_index = 4 },
        { name = 'path' },
    },
    experimental = { ghost_text = true },
})

lsp.setup() -- Must be called before native lsp

local min_error = { severity = { min = vim.diagnostic.severity.WARN } }

lsp.on_attach(function(client, bufnr)
    -- client.server_capabilities.semanticTokensProvider = nil
    vim.keymap.set({ 'n', 'v' }, 'K', function() vim.lsp.buf.hover() end, opts)

    vim.keymap.set('n', 'gdd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gdj', function() vim.diagnostic.goto_next(min_error) end, opts)
    vim.keymap.set('n', 'gdk', function() vim.diagnostic.goto_prev(min_error) end, opts)

    -- Set qf list but dont open it, just go to the first
    local function on_list(options)
        vim.fn.setqflist({}, ' ', options)
        vim.api.nvim_command('cfirst')
    end

    vim.keymap.set('n', 'gvr', function() vim.lsp.buf.references(nil, { on_list = on_list }) end, opts)
    vim.keymap.set('n', 'gvS', function() vim.lsp.buf.document_symbol({ on_list = on_list }) end, opts)
    vim.keymap.set('n', 'gvs', function() vim.lsp.buf.workspace_symbol(nil, { on_list = on_list }) end, opts)

    vim.keymap.set('n', 'gar', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ 'v', 'n' }, 'gaa', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set({ 'v', 'n' }, 'gaf', function() vim.lsp.buf.format { async = false } end, opts)
end)

vim.keymap.set({ 'n', 'v' }, 'gsj', '<cmd>cnext<cr>', {}, opts)
vim.keymap.set({ 'n', 'v' }, 'gsk', '<cmd>cprev<cr>', {}, opts)
vim.keymap.set({ 'n', 'v' }, 'gsx', '<cmd>cclose<cr>', {}, opts)

vim.diagnostic.config({
    virtual_text = min_error,
    update_in_insert = true,
    underline = false,
    signs = false,
    float = false,
})

local builtin = require('telescope.builtin')

require('telescope').setup({
    defaults = {
        border = true,
        layout_strategy = 'bottom_pane',
        layout_config = {
            bottom_pane = {
                prompt_position = 'bottom',
                height = 0.99,
                width = 0.99,
            },
        }
    },
})

vim.keymap.set('n', '<leader>F', builtin.live_grep, {})
vim.keymap.set('n', '<leader>H', builtin.help_tags, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>q', builtin.quickfix, {})
vim.keymap.set('n', '<leader>h', builtin.command_history, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>o', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>l', builtin.loclist, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>j', function()
    builtin.jumplist({ fname_width = 100 })
end, {})

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
vim.keymap.set('n', 'g.', mark.add_file)
vim.keymap.set('n', 'gm', ui.toggle_quick_menu)
vim.keymap.set('n', 'gn', function() ui.nav_next() end)
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
