local lsp = require("lsp-zero")
local null_ls = require("null-ls")
null_ls.setup({ sources = { null_ls.builtins.formatting.prettier, } })
lsp.nvim_lua_ls()

lsp.preset({
    name = "recommended",
    suggest_lsp_servers = false,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-t>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})

lsp.setup_nvim_cmp({
    -- Allows Enter key to be used freely.
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' }
    }
})

lsp.setup() -- Must be called before native lsp
lsp.on_attach(function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    vim.keymap.set('n', '<leader>k', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>D', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '<leader>w', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>a', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>h', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set('i', 'C-;', function() vim.lsp.buf.signature_help() end, opts)
end)

vim.api.nvim_create_augroup('diagnostics', { clear = true })
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = 'diagnostics',
    callback = function()
        vim.diagnostic.setqflist({ open = false })
    end,
})

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    underline = false,
    signs = false,
    float = false,
    severity_sort = true,
})

-- Mainly LSP stuff
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>b', builtin.git_branches, {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>H', builtin.help_tags, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>R', builtin.lsp_references, {})
-- Plain lines and minimal flair, please.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = nil,
        title = nil,
    })


-- Telescope and telescope accesories
local tele = require('telescope')
local defaults = {
    layout_strategy = 'flex',
    layout_config = { width = 0.95, height = 0.95, prompt_position = 'bottom' },
    wrap_results = true,
    border = false,
}

tele.setup { defaults = defaults }

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("harpoon").setup({
    menu = { width = vim.api.nvim_win_get_width(0) - 4, },
    global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,
        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,
        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,
        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },
        -- set marks specific to each git branch inside git repository
        mark_branch = false,
    }
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>z", mark.add_file)
vim.keymap.set("n", "<leader>x", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
