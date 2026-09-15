-- =====================================================
-- Nova API (main branch)
require("nvim-treesitter").setup({})

-- Instala os parsers que você usa (no-op se já instalado)
require("nvim-treesitter").install({
  "lua",
  "python",
  "html",
  "javascript",
  "css",
  "json",
  "jinja",
})

-- Ativa highlighting, indent e folds por filetype
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if not ok then
      return
    end
    vim.bo[ev.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldenable = false
  end,
})
