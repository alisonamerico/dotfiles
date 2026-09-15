-- =====================================================
-- General Editor Settings
-- =====================================================
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = true
opt.linebreak = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.swapfile = false
opt.winborder = "rounded"
opt.clipboard = "unnamedplus"
opt.colorcolumn = "80"
opt.cursorline = true
opt.completeopt = "menu,menuone,noselect,popup"
opt.conceallevel = 2
opt.concealcursor = "nc"
opt.laststatus = 3

-- Melhora o comportamento de busca (ignora maiúsculas a menos que digite uma)
opt.ignorecase = true
opt.smartcase = true

-- Mantém algumas linhas visíveis acima/abaixo do cursor ao rolar a página
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Suaviza a experiência de divisão de janelas (abrem abaixo e à direita)
opt.splitbelow = true
opt.splitright = true

-- Reduz o tempo de espera para disparar atalhos / quais-key (padrão é 1000ms)
opt.updatetime = 250
opt.timeoutlen = 300

-- Neovim 0.12: auto-completion em Insert mode (popup abre digitando).
-- Remova esta linha se preferir completion só com <C-Space>/trigger chars.
opt.autocomplete = true
