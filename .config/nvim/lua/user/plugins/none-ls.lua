return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- for lua
				null_ls.builtins.formatting.stylua,

				-- html, css javascript...
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.eslint_d, -- Javascript linter

				-- for python
				-- null_ls.builtins.formatting.blue,
				null_ls.builtins.formatting.ruff.with({
					extra_args = {
						"--line-length",
						"79",
					},
				}),
				null_ls.builtins.formatting.isort.with({
					extra_args = {
						"--line-length",
						"79",
						"--multi-line",
						"3",
						-- "--force-grid-wrap",
						-- "2",
						"--trailing-comma",
					},
				}),
				null_ls.builtins.diagnostics.ruff,
				
				-- for django template
				-- null_ls.builtins.formatting.djlint.with({
				-- 	filetypes = { "htmldjango" },
				-- }),
				null_ls.builtins.diagnostics.djlint
			},
		})
	end,
}
