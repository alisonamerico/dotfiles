local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup {
  debug = false,
  sources = {
    -- formatting
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
    formatting.djlint,
    formatting.isort,
    formatting.lua_format,
    formatting.prettierd,
    -- diagnostics
    diagnostics.flake8,
    diagnostics.djlint,
    diagnostics.stylelint,
  },
}

local mappings = {
	{ "n", "<leader>ca", vim.lsp.buf.code_action },
	{ "n", "<leader>af",  vim.lsp.buf.format },
}
for _, mapping in pairs(mappings) do
	vim.keymap.set(unpack(mapping))
end