-- =====================================================
-- General Editor Settings
-- =====================================================
vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.swapfile = false
opt.winborder = "rounded"
opt.clipboard = "unnamedplus"
opt.colorcolumn = "80"
opt.cursorline = true
opt.completeopt:append("noselect")
opt.conceallevel = 2
opt.concealcursor = "nc"
opt.laststatus = 3

-- =====================================================
-- Plugin Manager (vim.pack)
-- =====================================================
vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },

  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

  -- Completion
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- Utils
  { src = "https://github.com/ThePrimeagen/harpoon", name = "harpoon2" },
  { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
  { src = "https://github.com/akinsho/git-conflict.nvim" },
  { src = "https://github.com/epwalsh/obsidian.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/mbbill/undotree" },
  { src = "https://github.com/yetone/avante.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/HakonHarnes/img-clip.nvim" },
  { src = "https://github.com/3rd/image.nvim" },

  -- Theme
  { src = "https://github.com/vague-theme/vague.nvim" },
})

-- =====================================================
-- Theme
-- =====================================================
require("vague").setup({ transparent = true })
vim.cmd.colorscheme("vague")

-- =====================================================
-- Treesitter
-- =====================================================
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "python",
    "html",
    "javascript",
    "css",
    "json",
    "jinja",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- =====================================================
-- Mason + LSP (Neovim 0.11 native)
-- =====================================================
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ruff",
    "html",
    "cssls",
    "ts_ls",
    "jsonls",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config.ruff = { capabilities = capabilities }

vim.lsp.config.pyright = {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
    pyright = {
      disableOrganizeImports = true,
    },
  },
}

vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

vim.lsp.config.html = {
  capabilities = capabilities,
  filetypes = { "html", "htmldjango", "djangohtml" },
}

vim.lsp.config.cssls = { capabilities = capabilities }
vim.lsp.config.ts_ls = { capabilities = capabilities }
vim.lsp.config.jsonls = { capabilities = capabilities }

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ruff",
  "html",
  "cssls",
  "ts_ls",
  "jsonls",
})

-- =====================================================
-- Formatter (Conform)
-- =====================================================
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
    lua = { "stylua" },
    html = { "djlint" },
    htmldjango = { "djlint" },
    jinja = { "djlint" },
    css = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    toml = { "pyproject-fmt" },
  },
  format_on_save = { timeout_ms = 5000 },
})

-- =====================================================
-- Completion (nvim-cmp)
-- =====================================================
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- =====================================================
-- Plugins setup
-- =====================================================
require("oil").setup({ view_options = { show_hidden = true } })
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.statusline").setup()
require("gitsigns").setup({ current_line_blame = true })
require("git-conflict").setup()
require("ibl").setup()
require("image").setup()

-- =====================================================
-- Avante (Ollama)
-- =====================================================
require("avante").setup({
  provider = "ollama",
  providers = {
    ollama = {
      model = "qwen2.5:3b",
      endpoint = "http://127.0.0.1:11434",
      stream = true,
    },
  },
})

-- =====================================================
-- Keymaps (core)
-- =====================================================
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<Esc>", "<cmd>noh<cr>")
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>lf", function()
  require("conform").format({ async = true })
end)

map("n", "<leader>e", "<cmd>Oil<cr>")
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
map("n", "<leader>ac", "<cmd>AvanteChat<cr>")

-- =====================================================
-- Plugin management commands
-- =====================================================
vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update()
  vim.notify("Plugins updated", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("AddPlugin", function(opts)
  vim.pack.add({ { src = opts.args } })
end, { nargs = 1 })

vim.api.nvim_create_user_command("RemovePlugin", function(opts)
  vim.pack.del(opts.args)
end, { nargs = 1 })
