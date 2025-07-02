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

	local fabric_test_module = fmt(
		[[
        #[cfg(test)]
        mod test {{
            #[expect(unused_imports)]
            use fabric::{{account::AccountId, acquire, BoxResult, Pool}};

            use super::*;

            #[sqlx::test(
                migrations = "../../migrations",
                fixtures(path = "../../fixtures", scripts("account"))
            )]
            async fn my_test(pool: Pool) -> BoxResult {{
                let connection = acquire!(pool);
                let account = AccountId::fixture();
                {body}
                Ok(())
            }}
        }}
    ]],
		{ body = insert(1) }
	)
	local fabric_test = fmt(
		[[
        #[sqlx::test(
            migrations = "../../migrations",
            fixtures(path = "../../fixtures", scripts("account"))
        )]
        async fn {name}(pool: Pool) -> BoxResult {{
            let connection = acquire!(pool);
            let account = AccountId::fixture();
            {body}
            Ok(())
        }}
    ]],
		{ name = insert(1), body = insert(2) }
	)

	local bon = fmt(
		[[
        #[bon::bon]
        impl {type} {{
            #[builder(finish_fn = construct)]
            fn search<'_>(
                #[builder(finish_fn)]
                connection: fabric::Connection<'_>,
            ) -> fabric::Row<'c, Self> {{
                sqlx::query_as_unchecked!(
                    Self,
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
          async fn create(
              #[builder(finish_fn)]
              connection: fabric::Connection<'c>,
          ) -> sqlx::Result<Self> {{
              sqlx::query_as_unchecked!(
                  Self,
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
		snippet({ trig = "tmfm", name = "fabric test module" }, fabric_test_module),
		snippet({ trig = "tmf", name = "fabric test" }, fabric_test),
		snippet(
			{ trig = "ti", name = "instrument attribute" },
			fmt("#[tracing::instrument(skip({}), err)]", { insert(1) }, opts)
		),
		snippet({ trig = "ts", name = "ts_rs export" }, fmt('#[ts(export, export_to = "{}")]', { insert(1) }, opts)),
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
