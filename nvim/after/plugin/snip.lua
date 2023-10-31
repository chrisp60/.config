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
        "#[server]",
        fmt(
            [[
            #[server]
            {vis}async fn {name}({args}) -> Result<{rtn}, ServerFnError> {{
                {insert}
            }}
            ]],
            {
                insert = i(1),
                rtn = i(2, "()"),
                name = i(3, "fun_name_server"),
                args = i(4, ""),
                vis = c(5, { t(""), t("pub"), t("pub(crate)") }),
            }
        )
    ),
    s(
        "#[component]",
        fmt(
            [[
            #[component]
            {vis}fn {name}({args}) -> impl IntoView {{
                {insert}

            }}
            ]],
            {
                insert = i(1),
                name = i(2, "FunName"),
                args = i(3, ""),
                vis = c(4, { t(""), t("pub"), t("pub(crate)") }),
            }
        )
    ),
    s(
        "#[cfg(test)]",
        fmt(
            [[
            #[cfg(test)]
            mod test {{
                #[allow(unused_imports)]
                use super::*;

                #[{tokio}test{flavor}]
                fn fun_name_test() {{
                    {insert}

                }}
            }}
            ]],
            {
                insert = i(1),
                tokio = c(2, { t(""), t("tokio::") }),
                flavor = c(3, { t(""), t('(flavor = "multi_thread")') }),
            }
        )
    ),
    s(
        "#[derive(",
        fmt(
            [[
            #[derive(Debug, Clone{serde}{eqs}{ords})]
            ]],
            {
                serde = c(1, { t(""), t(", Serialize, Deserialize") }),
                eqs = c(2, { t(""), t(", PartialEq, Eq") }),
                ords = c(3, { t(""), t(", PartialOrd, Ord") }),
            }
        )
    ),
})
