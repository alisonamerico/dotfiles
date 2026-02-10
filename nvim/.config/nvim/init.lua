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

-- ========================================
-- Obsidian Setup
-- ========================================

-- util para normalizar títulos em slugs
local function slugify(str)
  local replacements = {
    ["á"] = "a",
    ["à"] = "a",
    ["ã"] = "a",
    ["â"] = "a",
    ["ä"] = "a",
    ["Á"] = "A",
    ["À"] = "A",
    ["Ã"] = "A",
    ["Â"] = "A",
    ["Ä"] = "A",
    ["é"] = "e",
    ["è"] = "e",
    ["ê"] = "e",
    ["ë"] = "e",
    ["É"] = "E",
    ["È"] = "E",
    ["Ê"] = "E",
    ["Ë"] = "E",
    ["í"] = "i",
    ["ì"] = "i",
    ["î"] = "i",
    ["ï"] = "i",
    ["Í"] = "I",
    ["Ì"] = "I",
    ["Î"] = "I",
    ["Ï"] = "I",
    ["ó"] = "o",
    ["ò"] = "o",
    ["õ"] = "o",
    ["ô"] = "o",
    ["ö"] = "o",
    ["Ó"] = "O",
    ["Ò"] = "O",
    ["Õ"] = "O",
    ["Ô"] = "O",
    ["Ö"] = "O",
    ["ú"] = "u",
    ["ù"] = "u",
    ["û"] = "u",
    ["ü"] = "u",
    ["Ú"] = "U",
    ["Ù"] = "U",
    ["Û"] = "U",
    ["Ü"] = "U",
    ["ç"] = "c",
    ["Ç"] = "C",
    ["ñ"] = "n",
    ["Ñ"] = "N",
  }
  -- substitui acentos
  str = str:gsub("[%z\1-\127\194-\244][\128-\191]*", replacements)
  -- troca espaço por hífen e remove caracteres inválidos
  str = str:gsub(" ", "-"):gsub("[^A-Za-z0-9%-]", "")
  -- colapsa múltiplos hífens
  str = str:gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
  return str:lower()
end

require("obsidian").setup({
  workspaces = {
    {
      name = "Notes",
      path = "$HOME/obsidian-notes/brain",
    },
  },

  note_id_func = function(title)
    local id = os.date("%Y%m%d%H%M")
    if title ~= nil then
      return id .. "-" .. slugify(title)
    else
      return id
    end
  end,

  note_frontmatter_func = function(note)
    local title = note.title or note.id
    return {
      id = note.id,
      title = title,
      aliases = { title },
      created = os.date("%Y-%m-%d %H:%M"),
      tags = note.tags,
    }
  end,

  templates = { folder = "_templates" },
  attachments = { img_folder = "_extras" },
  completion = { nvim_cmp = true },
  ui = { enable = true },
  picker = { name = "telescope.nvim" },
})

-- ========================================
-- img-clip Setup
-- ========================================
require("img-clip").setup({
  default = {
    -- caminho relativo ao diretório da nota
    dir_path = "_extras",
    -- formato de nome do arquivo
    insert_mode = true,
    -- formato do link inserido
    template = "![]({filePath})",
    file_name = function()
      -- gera timestamp + random para garantir unicidade
      return os.date("%Y-%m-%d-%H-%M-%S")
    end,
  },
})

-- ========================================
-- Keymaps
-- ========================================
vim.keymap.set("n", "<leader>o", ":update<cr> :source<cr>", { desc = "Save & reload config" })
vim.keymap.set("n", "<leader>w", ":write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "Previous quickfix" })

-- Clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d', { desc = "Cut to clipboard" })

-- Move Lines
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent
vim.keymap.set("n", "<A-l>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<A-h>", "<<", { desc = "Unindent line" })
vim.keymap.set("v", "<A-l>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<A-h>", "<gv", { desc = "Unindent selection" })

-- LSP Actions
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })

-- Git
local neogit = require("neogit")

-- Neogit status
vim.keymap.set("n", "<leader>gb", function()
  neogit.open()
end, { desc = "Git status" })

-- Stage all files
vim.keymap.set("n", "<leader>ga", function()
  vim.cmd("!git add .")
  vim.notify("✅ All files staged", vim.log.levels.INFO, { title = "Git" })
end, { desc = "Stage all files" })

-- Commit
vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Neogit commit" })

-- Pull / Push
vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>", { desc = "Neogit pull" })
vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>", { desc = "Neogit push" })

-- 🚀 Criar nova branch já com checkout
vim.keymap.set("n", "<leader>gN", function()
  vim.ui.input({ prompt = "🌱 New branch name: " }, function(input)
    if input and #input > 0 then
      vim.fn.system({ "git", "checkout", "-b", input })
      vim.notify("✅ Switched to new branch: " .. input, vim.log.levels.INFO, { title = "Git" })
    else
      vim.notify("⚠️ Branch name is required!", vim.log.levels.WARN, { title = "Git" })
    end
  end)
end, { desc = "Create new branch (from current)" })

-- Toggle blame
vim.keymap.set("n", "<leader>gB", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git blame" })

-- Git Conflict
vim.keymap.set("n", "<leader>cl", ":GitConflictListQf<CR>", { desc = "Choose ours" })
vim.keymap.set("n", "<leader>co", ":GitConflictChooseOurs<CR>", { desc = "Choose ours" })
vim.keymap.set("n", "<leader>ct", ":GitConflictChooseTheirs<CR>", { desc = "Choose theirs" })
vim.keymap.set("n", "<leader>cb", ":GitConflictChooseBoth<CR>", { desc = "Choose both" })
vim.keymap.set("n", "<leader>c0", ":GitConflictChooseNone<CR>", { desc = "Choose none" })
vim.keymap.set("n", "<leader>cn", ":GitConflictNextConflict<CR>", { desc = "Next conflict" })
vim.keymap.set("n", "<leader>cp", ":GitConflictPrevConflict<CR>", { desc = "Prev conflict" })

-- Gitsigns
vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { desc = "Next change" })
vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { desc = "Previous change" })
vim.keymap.set("n", "<leader>hd", require("gitsigns").preview_hunk, { desc = "Preview change (diff)" })
vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Revert change" })

-- Telescope

-- ~/.config/nvim/lua/plugins/telescope.lua
local telescope = require("telescope")

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--fixed-strings", -- treat pattern literally
    },
    -- prompt_prefix = "  ",
    -- selection_caret = " ",
    path_display = { "smart" },
  },
})

local builtin = require("telescope.builtin")

-- Keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>gl", builtin.git_branches, { desc = "Git Branches" })

vim.keymap.set("n", "<leader>dl", builtin.diagnostics, { desc = "Diagnostics list" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

-- File Explorer
vim.keymap.set("n", "<leader>e", ":Oil<cr>", { desc = "Open file explorer" })

-- Harpoon
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
require("harpoon").setup({ global_settings = { save_on_change = true, save_on_toggle = true } })

vim.keymap.set("n", "<leader>a", harpoon_mark.add_file, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>m", harpoon_ui.toggle_quick_menu, { desc = "Toggle Harpoon menu" })
vim.keymap.set("n", "<leader>1", function()
  harpoon_ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>2", function()
  harpoon_ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>3", function()
  harpoon_ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>4", function()
  harpoon_ui.nav_file(4)
end)

-- Tmux Navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
nvim_tmux_nav.setup({ disable_when_zoomed = true })
vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)

-- Obsidian
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open Obsidian vault" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch beetween notes" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow Obsidian link" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>oi", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Avante
vim.keymap.set("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Abrir Avante Chat" })

-- Plugin Management Commands
-- ===========================

-- Update all plugins
vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update()
  vim.notify("✅ Plugins updated!", vim.log.levels.INFO, { title = "vim.pack" })
end, { desc = "Update all plugins" })

-- Add a plugin
vim.api.nvim_create_user_command("AddPlugin", function(opts)
  if opts.args == "" then
    vim.notify("❌ Please provide a plugin URL", vim.log.levels.ERROR)
    return
  end
  vim.pack.add({ { src = opts.args } })
  vim.notify("➕ Plugin added: " .. opts.args, vim.log.levels.INFO)
end, { desc = "Add a plugin", nargs = 1 })

-- Remove a plugin
vim.api.nvim_create_user_command("RemovePlugin", function(opts)
  if opts.args == "" then
    vim.notify("❌ Please provide a plugin name", vim.log.levels.ERROR)
    return
  end
  vim.pack.del(opts.args)
  vim.notify("➖ Plugin removed: " .. opts.args, vim.log.levels.INFO)
end, { desc = "Remove a plugin", nargs = 1 })

-- ===========================
-- Keymaps
-- ===========================
local opts = { noremap = true, silent = true }

-- Update plugins
vim.keymap.set("n", "<leader>pu", ":UpdatePlugins<CR>", vim.tbl_extend("force", opts, { desc = "Update plugins" }))

-- Add plugin (requires entering URL)
vim.keymap.set("n", "<leader>pa", ":AddPlugin ", vim.tbl_extend("force", opts, { desc = "Add plugin (enter URL)" }))

-- Remove plugin (requires entering plugin name)
vim.keymap.set(
  "n",
  "<leader>pr",
  ":RemovePlugin ",
  vim.tbl_extend("force", opts, { desc = "Remove plugin (enter name)" })
)
