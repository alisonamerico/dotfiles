-- =====================================================
-- Completion nativa — substitui nvim-cmp + LuaSnip
-- (Neovim 0.11: vim.lsp.completion | expansão de snippet é built-in)
--
-- Teclas no popup: <C-n>/<C-p> navegam, <C-y> aceita,
-- <CR> confirma apenas com item selecionado (noselect evita
-- confirmação acidental).
--
-- <C-Space> dispara completion manualmente a qualquer momento — o
-- autotrigger (autotrigger=true) só dispara nos triggerCharacters que o
-- servidor declara (ex.: basedpyright só usa . [ " '), então digitar um
-- identificador solto (ex.: "from enum import Str") nunca abre o popup
-- sozinho. <C-Space> cobre esse caso sem depender de trigger character.
--
-- Além disso, replicamos a mesma lógica do autotrigger nativo, mas pra
-- qualquer caractere de identificador (letra/número/_) e também espaço —
-- não só nos triggerCharacters do servidor. Espaço entra porque é onde
-- você quer ver a lista sem ter digitado nenhuma letra ainda (ex.: logo
-- depois de "import "). É o que dá a sensação de "plugin de completion"
-- (digitou, apareceu) sem instalar nada. Debounce de 80ms evita disparar
-- uma requisição LSP a cada tecla; se o popup já estiver aberto, deixamos
-- o próprio Vim filtrar a lista já carregada (não refazemos a requisição
-- a cada letra digitada com o menu já visível).
-- =====================================================

local function should_trigger_char(char)
  return char == " " or (char ~= "" and char:match("[%w_]") ~= nil)
end

local ident_timers = {}

local function reset_ident_timer(bufnr)
  local timer = ident_timers[bufnr]
  if timer then
    timer:stop()
    timer:close()
    ident_timers[bufnr] = nil
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not (client and client:supports_method("textDocument/completion")) then
      return
    end

    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    vim.keymap.set("i", "<C-Space>", function()
      vim.lsp.completion.get()
    end, { buffer = ev.buf, desc = "Disparar completion do LSP manualmente" })

    local bufnr = ev.buf
    local group = vim.api.nvim_create_augroup("lsp_completion_ident_" .. bufnr, { clear = true })

    vim.api.nvim_create_autocmd("InsertCharPre", {
      group = group,
      buffer = bufnr,
      callback = function()
        if vim.fn.pumvisible() ~= 0 or not should_trigger_char(vim.v.char) then
          return
        end
        reset_ident_timer(bufnr)
        local timer = assert(vim.uv.new_timer())
        ident_timers[bufnr] = timer
        timer:start(
          80,
          0,
          vim.schedule_wrap(function()
            reset_ident_timer(bufnr)
            vim.lsp.completion.get()
          end)
        )
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      buffer = bufnr,
      callback = function()
        reset_ident_timer(bufnr)
      end,
    })
  end,
})
