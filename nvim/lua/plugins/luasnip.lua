local M = {
	"L3MON4D3/LuaSnip",
}

function M.config()
	local ls = require("luasnip")
	local text = ls.t
	local fmt = require("luasnip.extras.fmt").fmt
	local fmta = require("luasnip.extras.fmt").fmta
	local insert = ls.insert_node
	local snippet = ls.snippet
	local add_snippets = ls.add_snippets
	local choice = ls.choice_node

	local opts = { trim_empty = true, dedent = true }

	local bon = fmt(
		[[
        #[bon::bon]
        impl {type} {{
            #[builder(finish_fn = construct)]
            fn search<'c>(
                #[builder(finish_fn)]
                connection: &mut PgConnection
            ) -> fabric::Row<'c, Self> {{
                sqlx::query_as_unchecked!(Self,
                    r#"
                    "#
                )
            }}
        }}
    ]],
		{ type = ls.i(1) },
		opts
	)

	local bon_create = fmt(
		[[
      #[bon::bon]
      impl {type} {{
          #[builder(finish_fn = construct, start_fn = new)]
          pub async fn create(
              #[builder(finish_fn)]
              connection: &mut PgConnection,
          ) -> sqlx::Result<Self> {{
              sqlx::query_as_unchecked!(Self,
                  r#"
                  "#
              )
              .fetch_one(connection)
              .await
          }}
      }}
  ]],
		{ type = ls.i(1) },
		opts
	)

	add_snippets("rust", {
		snippet("impl search", bon),
		snippet("impl create", bon_create),
		snippet("#[tracing::instrument]", fmt("#[tracing::instrument(skip({}), err)]", { insert(1) }, opts)),
		snippet("#[expect", text('#[expect(dead_code, reason = "todo")]')),
		snippet("#[ts", fmt('#[ts(export, export_to = "{}")]', { insert(1) }, opts)),
		snippet("let connection", text([[let connection = fabric::acquire!(pool);]])),
	})

	add_snippets("svelte", {
		snippet(
			"let",
			fmt("let {name} = ${kind}({expr})", {
				name = insert(1),
				kind = insert(2),
				expr = insert(3),
			}, opts)
		),
		snippet("<script", fmt('<script lang="ts">{}</script>', { insert(1) }), opts),
	})
end

return M
