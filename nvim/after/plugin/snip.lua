local ls = require("luasnip")

vim.keymap.set({ "i" }, "<C-l>", ls.expand)

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    ls.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

--- @diagnostic disable:unused-local
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("rust", {
    s(
        "ls",
        fmt(
            [[
                #[server]
                {}async fn {}({}) -> Result<{}, ServerFnError> {{
                    todo!()
                }}
            ]],
            { c(1, { t("pub "), t("") }), i(2, "foo"), i(3, "_v: ()"), i(4, "()") }
        )
    ),
    s(
        "lc",
        fmt(
            [[
            #[component{}]
            {}fn {}() -> impl IntoView {{
                view! {{}}
            }}
            ]],
            {
                c(1, { t(""), t("(transparent)") }),
                c(2, { t("pub "), t("") }),
                i(3, "Foo"),
            }
        )
    ),
    s(
        "struct",
        fmt(
            [[
            {import_serde}
            #[derive(Serialize, Deserialize, Debug, Clone)]
            {vis}struct {struct_name} {{}}
            ]],
            {
                import_serde = c(1, { t(""), t("use serde::{Deserialize, Serialize};") }),
                vis = c(2, { t(""), t("pub "), t("pub(crate) ") }),
                struct_name = i(3, "FooStruct"),
            }
        )
    ),
    s(
        "test",
        fmt(
            [[
            #[cfg(test)]
            mod test {{
                #[allow(unused_imports)]
                use super::*;

                #[test]
                fn {fn_name}() {{}}
            }}
            ]],
            {
                fn_name = i(1, "foo_test"),
            }
        )
    ),
    s(
        "ustruct",
        fmt(
            [[
            #[derive(Serialize, Deserialize, Debug, Clone)]
            {vis}struct {struct_name}({type});
            ]],
            {
                vis = c(1, { t(""), t("pub "), t("pub(crate) ") }),
                struct_name = i(2, "FooUnit"),
                type = i(3, "Type"),
            }
        )
    ),
    s(
        "#[deri",
        fmt(
            [[
            #[derive(Debug, {ser}{de}{clone}{peq}{pord}{eq}{ord}{other})]
            ]],
            {
                ser = c(1, { t("Serialize, "), t(""), }),
                de = c(2, { t("Deserialize, "), t(""), }),
                clone = c(3, { t("Clone, "), t(""), }),
                peq = c(4, { t("PartialEq, "), t(""), }),
                pord = c(5, { t("PartialOrd, "), t(""), }),
                eq = c(6, { t("Eq, "), t(""), }),
                ord = c(7, { t("Ord, "), t(""), }),
                other = i(8, "SomeDerive"),
            }
        )
    ),
    s(
        "//",
        fmt(
            [[
            ////////////////////////////////////////////////////////////////////////////////
            // {section_name}
            ////////////////////////////////////////////////////////////////////////////////
            ]],
            {
                section_name = i(1, "section name"),
            }
        )
    ),
})
