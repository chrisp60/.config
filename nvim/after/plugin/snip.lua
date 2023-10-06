---@diagnostic disable: unused-local, undefined-global

local ls = require("luasnip")
local snip = ls.snippet
-- local snip_node = ls.snippet_node
-- local indent_snip_node = ls.indent_snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dyn = ls.dynamic_node
local rest = ls.restore_node

vim.keymap.set({ 'i', 'n' }, '<C-E>', function() require('luasnip').expand() end, { desc = 'snip expand' })


ls.add_snippets("all", {
    snip("#[serv", {
        text('#[leptos::server]', {
            text('async fn '),
        }),
        insert(1, 'name'),
        text('( )'),
        text(' -> Result<'), insert(2, 'ret'), text(' ServerFnError> {}')
    })
})


