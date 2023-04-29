require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = false,
    show_end_of_buffer = true,
    term_colors = true,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = true,
    no_bold = false,
    styles = {
        comments = { 'bold' },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = { 'bold' },
        strings = {},
        variables = {},
        numbers = { 'bold' },
        booleans = {},
        properties = {},
        types = { 'bold' },
        operators = { 'bold' },
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        native_lsp = { enabled = true },
        cmp = true,
        gitsigns = false,
        nvimtree = false,
        telescope = true,
        notify = false,
        mini = false,
        harpoon = true,
        vimwiki = true,
        mason = true,
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
-- Pairs highlights
vim.cmd [[:highlight MatchParen cterm=bold ctermbg=black ctermfg=NONE]]
vim.cmd [[:highlight MatchParen gui=bold guibg=black guifg=NONE]]
