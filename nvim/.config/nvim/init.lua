-- ========================================
-- General Editor Settings
-- ========================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.cmd("set completeopt+=noselect")
-- Conceal settings for Obsidian
vim.o.conceallevel = 2
vim.o.concealcursor = "nc" -- Conceal em normal + command mode
-- ========================================
-- Plugin Manager (vim.pack)
-- ========================================
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon", name = "harpoon2" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/sschleemilch/slimline.nvim" },
	{ src = "https://github.com/akinsho/git-conflict.nvim" },
	{ src = "https://github.com/epwalsh/obsidian.nvim" },
})

-- ========================================
-- Catppuccin Setup
-- ========================================
require("catppuccin").setup({
	transparent = true,
	integrations = { treesitter = true, native_lsp = true, cmp = true },
})
vim.cmd("colorscheme catppuccin")

-- ========================================
-- Treesitter Setup (HTML + Jinja + other)
-- ========================================
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "python", "html", "javascript", "css", "json", "jinja" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "html" },
	},
	indent = { enable = true },
})

-- ========================================
-- Autocmd for Jinja Templates (Flask/Django)
-- ========================================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.html", "*.htm" },
	callback = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for _, line in ipairs(lines) do
			if line:match("{%%") or line:match("{{") then
				-- Force HTML base and custom Jinja syntax
				vim.bo.filetype = "html"
				vim.cmd([[
                    syntax include @Jinja syntax/jinja.vim
                    syn region JinjaBlock start=/{%/ end=/%}/ contains=@Jinja
                    syn region JinjaExpr start=/{{/ end=/}}/ contains=@Jinja
                ]])

				break
			end
		end
	end,
})

-- ========================================
-- Plugin Setup
-- ========================================
require("mason").setup()
require("oil").setup()
require("git-conflict").setup()
require("slimline").setup({
	style = "fg",
	hl = {
		base = "Normal",
		primary = "Normal",
		secondary = "Comment",
		SlimlineModeNormal = { fg = "#00ff00", bg = nil },
		SlimlineModeInsert = { fg = "#ffff00", bg = nil },
		SlimlineModeVisual = { fg = "#ff00ff", bg = nil },
		SlimlineModeReplace = { fg = "#ff0000", bg = nil },
		SlimlineModeCommand = { fg = "#00ffff", bg = nil },
	},
	spaces = { components = "", left = " ", right = " " },
})
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("gitsigns").setup({ current_line_blame = true })

-- ========================================
-- Formatter Setup (Conform)
-- ========================================
require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_fix", "ruff_format" },
		lua = { "stylua" },
	},
	formatters = {
		ruff_fix = {
			command = "ruff",
			args = { "check", "--fix", "--exit-zero", "--stdin-filename", "$FILENAME", "-" },
			stdin = true,
		},
		ruff_format = {
			command = "ruff",
			args = { "format", "--stdin-filename", "$FILENAME", "-" },
			stdin = true,
		},
	},
	format_on_save = { timeout_ms = 5000, lsp_fallback = false },
})

-- ========================================
-- LSP Setup
-- ========================================
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")
lspconfig.ruff.setup({ capabilities = capabilities })
lspconfig.pyright.setup({
	capabilities = capabilities,
	settings = {
		python = { analysis = { autoImportCompletions = true, typeCheckingMode = "basic" } },
		pyright = { disableOrganizeImports = true },
	},
})
-- HTML
lspconfig.html.setup({
	capabilities = capabilities,
})

-- -- CSS
-- lspconfig.css_ls.setup({
-- 	capabilities = capabilities,
-- })
--
-- -- JavaScript/TypeScript
-- lspconfig.tsserver.setup({
-- 	capabilities = capabilities,
-- })
lspconfig.lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
vim.lsp.enable({ "lua_ls", "pyright", "ruff", "html" })
-- ========================================
-- Autocomplete Setup
-- ========================================
local cmp = require("cmp")
cmp.setup({
	snippet = { expand = function(_) end },
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" }, -- Sugestões do LSP (HTML, CSS, JS, Python)
		{ name = "buffer" }, -- Sugestões do buffer atual
		{ name = "path" }, -- Sugestões de caminhos de arquivos
	},
})

-- ========================================
-- Obsidian Setup
-- ========================================
require("obsidian").setup({
	-- opts = {
	workspaces = {
		{
			name = "Notes",
			path = "/home/alison/obsidian-notes/brain",
		},
	},

	templates = {
		folder = "_templates",
	},

	attachments = {
		img_folder = "_extras",
		filetypes = { "png", "jpg", "jpeg", "pdf" },
	},

	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},

	ui = { enable = true },
	picker = { name = "telescope.nvim" },
	-- },
})

-- ========================================
-- Keymaps
-- ========================================
vim.keymap.set("n", "<leader>o", ":update<cr> :source<cr>", { desc = "Save & reload config" })
vim.keymap.set("n", "<leader>w", ":write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })

-- Clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<cr>', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<cr>', { desc = "Cut to clipboard" })

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

-- Toggle blame
vim.keymap.set("n", "<leader>gB", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git blame" })

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

-- Git Conflict
vim.keymap.set("n", "<leader>co", "<cmd>GitConflictChooseOurs<CR>", { desc = "Choose ours" })
vim.keymap.set("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Choose theirs" })
vim.keymap.set("n", "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Choose both" })
vim.keymap.set("n", "<leader>c0", "<cmd>GitConflictChooseNone<CR>", { desc = "Choose none" })
vim.keymap.set("n", "<leader>cn", "<cmd>GitConflictNextConflict<CR>", { desc = "Next conflict" })
vim.keymap.set("n", "<leader>cp", "<cmd>GitConflictPrevConflict<CR>", { desc = "Prev conflict" })

-- Telescope
local builtin = require("telescope.builtin")
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
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow Obsidian link" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })

-- ===========================
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
