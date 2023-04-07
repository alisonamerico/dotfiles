-- [[ Setting options ]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.python3_host_prog = "python"
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.doge_enable_mappings = 1
vim.g.doge_mapping = '<Leader>d'

local options = {
  autoindent = true,
  autoread = true,
  breakindent = true,
  clipboard = "unnamed,unnamedplus", -- Sync with system clipboard.
  confirm = true,                    -- Confirm to save changes before exiting modified buffer.
  cursorline = true,                 -- Enable highlighting of the current line.
  expandtab = true,                  -- Use spaces instead of tabs.
  foldenable = false,
  hidden = true,
  ignorecase = true,
  mouse = "a",           -- Enable mouse mode.
  number = true,         -- Print line number.
  relativenumber = true, -- Set relative line numbers.
  scrolloff = 5,         -- Lines of context.
  shell = "/bin/bash",
  shiftwidth = 4,
  smartcase = true,
  smartindent = true,
  softtabstop = 4,
  splitbelow = true,
  splitright = true,
  tabstop = 4,
  termguicolors = true, -- True color support.
  wildignore = "*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite",
  laststatus = 3,
  updatetime = 500,
  completeopt = "menu,menuone,preview,noselect",
  shortmess = vim.opt.shortmess + "c",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
