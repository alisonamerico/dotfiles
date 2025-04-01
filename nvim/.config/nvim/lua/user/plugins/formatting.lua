-- return {
--   "stevearc/conform.nvim",
--   opts = {
--     formatters_by_ft = {
--       lua = { "stylua" },
--       -- Conform will run multiple formatters sequentially
--       python = { "ruff", "blue", "mypy" },
--       -- You can customize some of the format options for the filetype (:help conform.format)
--       -- rust = { "rustfmt" },
--       -- Conform will run the first available formatter
--       javascript = { "prettierd", "prettier", stop_after_first = true },
--       typescript = { "prettierd", "prettier", stop_after_first = true },
--     },
--     format_on_save = {
--       -- These options will be passed to conform.format()
--       timeout_ms = 6000,
--       lsp_format = "fallback",
--     },
--   },
-- }
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local ok, conform = pcall(require, "conform")
    if not ok then
      vim.notify("conform.nvim not found: " .. conform)
      return
    end

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        htmldjango = { "djlint" },
        lua = { "stylua" },
        python = { "isort", "blue", "ruff", "mypy" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 6000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
