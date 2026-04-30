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
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

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
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
  { src = "https://github.com/obsidian-nvim/obsidian.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/mbbill/undotree" },
  { src = "https://github.com/yetone/avante.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/HakonHarnes/img-clip.nvim" },
  { src = "https://github.com/3rd/image.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },

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

-- =====================================================
-- Mason + LSP (Neovim 0.11 native)
-- =====================================================
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "taplo",
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
vim.lsp.config.taplo = { capabilities = capabilities }

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "taplo",
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
    toml = { "taplo" },
    markdown = { "mdformat" },
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
require("ibl").setup()
require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "obsidian" },
    },
  },
})

require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    default = { layout = "diff2_horizontal" },
    merge_tool = { layout = "diff3_horizontal" },
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
      name = "brain",
      path = "$HOME/obsidian-notes/brain",
    },
  },

  use_titles = true,
  new_notes_location = "Notes",

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
  ui = {
    enable = true,
    floor_dir = "~/.cache/obsidian.nvim/floor",
  },
  picker = { name = "telescope.nvim" },

  daily_notes = {
    folder = "Journal",
    template = "Daily Note.md",
    date_format = "%Y/%m/%Y-%m-%d %a",
  },

  wiki_link_func = function(opts)
    return string.format("[[%s]]", opts.label)
  end,

  markdown_proc_func = function(ctx)
    return require("obsidian").markdown_proc(ctx, function(s)
      return s:gsub("{{date}}", function()
        return os.date("%Y-%m-%d")
      end)
    end)
  end,

  follow_url_func = function(url)
    vim.fn.jobstart({ "xdg-open", url })
  end,
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
-- Render Markdown Setup
-- ========================================
-- require("render-markdown").setup({
--   file_types = { "markdown", "obsidian" },
-- })

-- ========================================
-- Keymaps
-- ========================================
vim.keymap.set("n", "<leader>o", ":update<cr> :source<cr>", { desc = "Save & reload config" })
vim.keymap.set("n", "<leader>w", ":write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "Previous quickfix" })

-- Replace the word cursor is on globally
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

-- restart
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", {
  desc = "Restart Neovim (:restart)",
  silent = true,
})

-- Obsidian: Follow wikilink
vim.keymap.set("n", "gf", "<cmd>lua require('obsidian').util.gf_passthrough()<CR>", { desc = "Follow link (gf)" })
vim.keymap.set("n", "<CR>", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Toggle checkbox" })
vim.keymap.set("n", "gx", "<cmd>lua require('obsidian').util.open_in_browser()<CR>", { desc = "Open link in browser" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian app" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })

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

-- ========================================
-- Git Functions
-- ========================================
local function git_commit()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if msg and #msg > 0 then
      vim.fn.system({ "git", "commit", "-m", msg })
      vim.notify("✅ Commit created", vim.log.levels.INFO, { title = "Git" })
      vim.cmd("checktime")
    end
  end)
end

local function git_amend()
  vim.ui.input({ prompt = "Amend message (leave empty to keep previous): " }, function(msg)
    local cmd = msg and #msg > 0 and { "git", "commit", "--amend", "-m", msg }
      or { "git", "commit", "--amend", "--no-edit" }
    vim.fn.system(cmd)
    vim.notify("✅ Commit amended", vim.log.levels.INFO, { title = "Git" })
    vim.cmd("checktime")
  end)
end

local function git_stash()
  vim.ui.input({ prompt = "Stash message (optional): " }, function(msg)
    local cmd = msg and #msg > 0 and { "git", "stash", "push", "-m", msg } or { "git", "stash", "push" }
    vim.fn.system(cmd)
    vim.notify("✅ Stashed", vim.log.levels.INFO, { title = "Git" })
    vim.cmd("checktime")
  end)
end

local function git_status()
  local output = vim.fn.system("git status --short")
  if output == "" then
    vim.notify("✅ Working tree clean", vim.log.levels.INFO, { title = "Git" })
  else
    print(output)
  end
end

local function git_fetch()
  vim.fn.system({ "git", "fetch", "--all" })
  vim.notify("✅ Fetched all remotes", vim.log.levels.INFO, { title = "Git" })
end

-- ========================================
-- Git Keymaps
-- ========================================
local gitsigns = require("gitsigns")

vim.keymap.set("n", "]c", gitsigns.next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "[c", gitsigns.prev_hunk, { desc = "Prev hunk" })

vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Unstage hunk" })
vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gU", function()
  local filepath = vim.fn.expand("%:p")
  vim.fn.system({ "git", "reset", "HEAD", filepath })
  vim.notify("✅ Unstaged: " .. vim.fn.fnamemodify(filepath, ":."), vim.log.levels.INFO, { title = "Git" })
  vim.cmd("checktime")
end, { desc = "Unstage buffer" })
vim.keymap.set("n", "<leader>gr", function()
  local filepath = vim.fn.expand("%")
  vim.ui.input({
    prompt = "Discard all changes in this file? (yes to confirm): ",
  }, function(ans)
    if ans == "yes" then
      vim.fn.system({ "git", "restore", filepath })
      vim.notify("✅ Changes discarded", vim.log.levels.INFO, { title = "Git" })
      vim.cmd("checktime")
    end
  end)
end, { desc = "Discard changes" })
vim.keymap.set("n", "<leader>gc", git_commit, { desc = "Commit" })
vim.keymap.set("n", "<leader>gA", git_amend, { desc = "Amend" })

vim.keymap.set("n", "<leader>gp", function()
  vim.fn.system({ "git", "pull" })
  vim.notify("✅ Pulled", vim.log.levels.INFO, { title = "Git" })
  vim.cmd("checktime")
end, { desc = "Pull" })
vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>gF", git_fetch, { desc = "Fetch" })

vim.keymap.set("n", "<leader>gn", function()
  vim.ui.input({ prompt = "New branch name: " }, function(name)
    if name and #name > 0 then
      vim.fn.system({ "git", "checkout", "-b", name })
      vim.notify("✅ Switched to: " .. name, vim.log.levels.INFO, { title = "Git" })
    end
  end)
end, { desc = "New branch" })

vim.keymap.set("n", "<leader>gm", function()
  vim.ui.input({ prompt = "Branch to merge: " }, function(branch)
    if branch and #branch > 0 then
      vim.fn.system({ "git", "merge", branch })
      vim.notify("Merged branch: " .. branch, vim.log.levels.INFO, { title = "Git" })
      vim.cmd("checktime")
    end
  end)
end, { desc = "Merge" })

vim.keymap.set("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })

vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

vim.keymap.set("n", "<leader>gP", function()
  vim.fn.system("git add -p")
end, { desc = "Patch stage" })

vim.keymap.set("n", "<leader>gR", function()
  require("telescope.builtin").git_branches()
end, { desc = "Git reflog" })

vim.keymap.set("n", "<leader>co", ":diffget LOCAL<CR>")
vim.keymap.set("n", "<leader>ct", ":diffget REMOTE<CR>")
vim.keymap.set("n", "<leader>cb", ":diffget BASE<CR>")

vim.keymap.set("n", "<leader>go", ":DiffviewOpen<CR>", { desc = "Diffview" })
vim.keymap.set("n", "<leader>gO", function()
  vim.ui.input({ prompt = "Branch to compare with: " }, function(branch)
    if branch and #branch > 0 then
      vim.cmd("DiffviewOpen " .. branch .. "..HEAD")
    end
  end)
end, { desc = "Diff branches" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "History" })

vim.keymap.set("n", "<leader>gt", git_status, { desc = "Status" })
vim.keymap.set("n", "<leader>ga", function()
  vim.fn.system({ "git", "add", "-A" })
  vim.notify("✅ All files staged", vim.log.levels.INFO, { title = "Git" })
  vim.cmd("checktime")
end, { desc = "Stage all" })
vim.keymap.set("n", "<leader>gz", git_stash, { desc = "Stash" })
vim.keymap.set("n", "<leader>gZ", function()
  vim.fn.system({ "git", "stash", "pop" })
  vim.notify("✅ Stash popped", vim.log.levels.INFO, { title = "Git" })
  vim.cmd("checktime")
end, { desc = "Stash pop" })
vim.keymap.set("n", "<leader>gL", function()
  require("telescope.builtin").git_commits()
end, { desc = "Log commits" })
vim.keymap.set("n", "gL", function()
  require("telescope.builtin").git_commits()
end, { desc = "Log commits" })

vim.keymap.set("n", "<leader>gm", function()
  vim.ui.input({ prompt = "Branch to merge: " }, function(branch)
    if branch and #branch > 0 then
      vim.fn.system({ "git", "merge", branch })
      vim.notify("Merged branch: " .. branch, vim.log.levels.INFO, { title = "Git" })
      vim.cmd("checktime")
    end
  end)
end, { desc = "Merge (with confirmation)" })

vim.keymap.set("n", "<leader>g!", function()
  vim.ui.input({ prompt = "Force push? (yes to confirm): " }, function(ans)
    if ans == "yes" then
      vim.fn.system({ "git", "push", "--force" })
      vim.notify("⚠️ Force pushed!", vim.log.levels.WARN, { title = "Git" })
    end
  end)
end, { desc = "Force push" })

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
      "--fixed-strings", -- treat pattern literalmente
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
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })

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
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Open yesterday's note" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianTomorrow<cr>", { desc = "Open tomorrow's note" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>ox", "<cmd>ObsidianLink<cr>", { desc = "Insert link" })
vim.keymap.set("n", "<leader>oz", "<cmd>ObsidianLinkNew<cr>", { desc = "Create and link note" })

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

-- ===========================
-- Which-Key Configuration
-- ===========================
local wk = require("which-key")

wk.setup({
  preset = "helix",
  delay = 0,
  triggers = {
    { "<leader>", mode = { "n", "v" } },
  },
  plugins = {
    marks = true,
    registers = true,
  },
  win = {
    border = "rounded",
    padding = { 2, 4 },
  },
})

wk.add({
  -- Grupos principais
  { "<leader>f", group = "find (telescope)" },
  { "<leader>g", group = "git" },
  { "<leader>o", group = "obsidian" },
  { "<leader>l", group = "lsp" },
  { "<leader>d", group = "diagnostics" },
  { "<leader>p", group = "plugins" },
  { "<leader>a", group = "avante / harpoon" },

  -- Git (prefixo <leader>g)
  { "<leader>gc", desc = "commit" },
  { "<leader>gA", desc = "amend" },
  { "<leader>gp", desc = "pull" },
  { "<leader>gd", desc = "preview hunk" },
  { "<leader>gl", desc = "log commits" },
  { "<leader>gF", desc = "fetch" },
  { "<leader>g!", desc = "force push" },
  { "<leader>gS", desc = "stage buffer" },
  { "<leader>gU", desc = "unstage buffer" },
  { "<leader>gs", desc = "stage hunk" },
  { "<leader>ga", desc = "stage all" },
  { "<leader>gu", desc = "unstage hunk" },
  { "<leader>gr", desc = "discard changes" },
  { "<leader>gn", desc = "new branch" },
  { "<leader>gm", desc = "merge" },
  { "<leader>gB", desc = "toggle blame" },
  { "<leader>go", desc = "diffview open" },
  { "<leader>gO", desc = "diff branches" },
  { "<leader>gh", desc = "file history" },
  { "<leader>gt", desc = "git status" },
  { "<leader>gz", desc = "stash" },
  { "<leader>gZ", desc = "stash pop" },
  { "<leader>gL", desc = "log commits" },
  { "<leader>gg", desc = "lazygit" },
  { "<leader>gP", desc = "patch stage" },
  { "<leader>gR", desc = "git reflog" },
  { "<leader>co", desc = "diffget local" },
  { "<leader>ct", desc = "diffget remote" },
  { "<leader>cb", desc = "diffget base" },
})
