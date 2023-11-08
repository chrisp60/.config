local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    preselect = "none",
    completion = { completeopt = "menu,menuone,noselectpreview" },
    mapping = {
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = {
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Snippet"
            end,
        },
        { name = "path" },
    },
    experimental = { ghost_text = false },
})
