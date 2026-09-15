-- =====================================================
-- Completion nativa — substitui nvim-cmp + LuaSnip
-- (Neovim 0.11: vim.lsp.completion | expansão de snippet é built-in)
--
-- Teclas no popup: <C-n>/<C-p> navegam, <C-y> aceita,
-- <CR> confirma apenas com item selecionado (noselect evita
-- confirmação acidental).
-- =====================================================
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
