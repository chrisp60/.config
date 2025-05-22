local snipet = function()
	local ls = require("luasnip")
	local t = ls.t
	local fmt = require("luasnip.extras.fmt").fmt
	--

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
		{ trim_empty = true, dedent = true }
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
		{ trim_empty = true, dedent = true }
	)
	ls.add_snippets("rust", {
		ls.snippet("impl search", bon),
		ls.snippet("impl create", bon_create),
		ls.snippet("#expect", t('#[expect(dead_code, reason = "todo")]')),
	})
end

return {
	"L3MON4D3/LuaSnip",
	config = snipet,
}
