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
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    },
    sources = {
        { name = "neorg" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
    },
    experimental = { ghost_text = false },
})
