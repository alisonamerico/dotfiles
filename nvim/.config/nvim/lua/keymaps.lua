-- =====================================================
-- Keymaps
-- =====================================================

-- Gerais
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

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart Neovim (:restart)", silent = true })

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

-- Diagnostics (vim.diagnostic.jump substitui goto_next/goto_prev, deprecated no 0.11)
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })

-- =====================================================
-- Git Functions (vim.system — assíncrono, sem bloquear a UI)
-- =====================================================

--- Roda git de forma assíncrona. Notifica erro com stderr em caso de falha.
---@param args string[] ex: { "git", "commit", "-m", msg }
---@param opts? { success?: string, on_stdout?: fun(stdout: string) }
local function git(args, opts)
	opts = opts or {}
	return vim.system(args, { text = true }, function(out)
		vim.schedule(function()
			if out.code ~= 0 then
				vim.notify(
					("❌ `git %s` falhou (exit %d):\n%s"):format(
						args[2] or "",
						out.code,
						(out.stderr or ""):gsub("%s+$", "")
					),
					vim.log.levels.ERROR,
					{ title = "Git" }
				)
				return
			end
			if opts.success then
				vim.notify(opts.success, vim.log.levels.INFO, { title = "Git" })
			end
			vim.cmd("checktime")
			if opts.on_stdout then
				opts.on_stdout((out.stdout or ""):gsub("%s+$", ""))
			end
		end)
	end)
end

local function git_commit()
	vim.ui.input({ prompt = "Commit message: " }, function(msg)
		if msg and #msg > 0 then
			git({ "git", "commit", "-m", msg }, { success = "✅ Commit created" })
		end
	end)
end

local function git_amend()
	vim.ui.input({ prompt = "Amend message (leave empty to keep previous): " }, function(msg)
		local args = msg and #msg > 0 and { "git", "commit", "--amend", "-m", msg }
			or { "git", "commit", "--amend", "--no-edit" }
		git(args, { success = "✅ Commit amended" })
	end)
end

local function git_stash()
	vim.ui.input({ prompt = "Stash message (optional): " }, function(msg)
		local args = msg and #msg > 0 and { "git", "stash", "push", "-m", msg } or { "git", "stash", "push" }
		git(args, { success = "✅ Stashed" })
	end)
end

local function git_status()
	git({ "git", "status", "--short" }, {
		on_stdout = function(stdout)
			if stdout == "" then
				vim.notify("✅ Working tree clean", vim.log.levels.INFO, { title = "Git" })
			else
				print(stdout)
			end
		end,
	})
end

-- =====================================================
-- Git Keymaps
-- =====================================================
local gitsigns = require("gitsigns")

vim.keymap.set("n", "]c", gitsigns.next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "[c", gitsigns.prev_hunk, { desc = "Prev hunk" })

vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Unstage hunk" })
vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gU", function()
	local filepath = vim.fn.expand("%:p")
	git({ "git", "reset", "HEAD", filepath }, { success = "✅ Unstaged: " .. vim.fn.fnamemodify(filepath, ":.") })
end, { desc = "Unstage buffer" })
vim.keymap.set("n", "<leader>gr", function()
	local filepath = vim.fn.expand("%")
	vim.ui.input({ prompt = "Discard all changes in this file? (yes to confirm): " }, function(ans)
		if ans == "yes" then
			git({ "git", "restore", filepath }, { success = "✅ Changes discarded" })
		end
	end)
end, { desc = "Discard changes" })
vim.keymap.set("n", "<leader>gc", git_commit, { desc = "Commit" })
vim.keymap.set("n", "<leader>gA", git_amend, { desc = "Amend" })

vim.keymap.set("n", "<leader>gp", function()
	git({ "git", "pull" }, { success = "✅ Pulled" })
end, { desc = "Pull" })
vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>gF", function()
	git({ "git", "fetch", "--all" }, { success = "✅ Fetched all remotes" })
end, { desc = "Fetch" })

vim.keymap.set("n", "<leader>gn", function()
	vim.ui.input({ prompt = "New branch name: " }, function(name)
		if name and #name > 0 then
			git({ "git", "checkout", "-b", name }, { success = "✅ Switched to: " .. name })
		end
	end)
end, { desc = "New branch" })

vim.keymap.set("n", "<leader>gm", function()
	vim.ui.input({ prompt = "Branch to merge: " }, function(branch)
		if branch and #branch > 0 then
			git({ "git", "merge", branch }, { success = "Merged branch: " .. branch })
		end
	end)
end, { desc = "Merge" })

vim.keymap.set("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })

-- LazyGit: sem plugin, fecha o terminal/buffer automaticamente ao sair
vim.keymap.set("n", "<leader>gg", function()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.fn.termopen("lazygit", {
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})

	vim.cmd.startinsert()
end, { desc = "Open LazyGit" })

-- git add -p é interativo: precisa de terminal, não de vim.system
vim.keymap.set("n", "<leader>gP", function()
	vim.cmd.terminal("git add -p")
	vim.cmd.startinsert()
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
	git({ "git", "add", "-A" }, { success = "✅ All files staged" })
end, { desc = "Stage all" })
vim.keymap.set("n", "<leader>gz", git_stash, { desc = "Stash" })
vim.keymap.set("n", "<leader>gZ", function()
	git({ "git", "stash", "pop" }, { success = "✅ Stash popped" })
end, { desc = "Stash pop" })
vim.keymap.set("n", "<leader>gl", function()
	require("telescope.builtin").git_commits()
end, { desc = "Log commits" })

vim.keymap.set("n", "<leader>gX", function()
	vim.ui.input({ prompt = "Rebase onto branch: " }, function(branch)
		if branch and #branch > 0 then
			git({ "git", "rebase", branch }, { success = "Rebased onto: " .. branch })
		end
	end)
end, { desc = "Rebase onto branch" })

vim.keymap.set("n", "<leader>g!", function()
	vim.ui.input({ prompt = "Force push? (yes to confirm): " }, function(ans)
		if ans == "yes" then
			git({ "git", "push", "--force" }, { success = "⚠️ Force pushed!" })
		end
	end)
end, { desc = "Force push" })

-- =====================================================
-- Telescope
-- =====================================================
require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		path_display = { "smart" },
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>dl", builtin.diagnostics, { desc = "Diagnostics list" })

-- File Explorer
vim.keymap.set("n", "-", ":Oil<cr>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>e", function()
	local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	require("oil").open(root)
end, { desc = "Open Oil root project (Git)" })

-- =====================================================
-- Grapple (Substituto moderno do Harpoon)
-- =====================================================
local grapple = require("grapple")

grapple.setup({
	scope = "git_branch", -- Salva as marcas separadas por branch do Git
})

-- Adicionar o arquivo atual à lista
vim.keymap.set("n", "<leader>a", function()
	grapple.tag()
	vim.notify("📌 File added to Grapple", vim.log.levels.INFO)
end, { desc = "Grapple: Add File" })

-- Abrir o menu flutuante (Navegue com j/k, remova com d, abra com Enter)
vim.keymap.set("n", "<leader>m", function()
	grapple.open_tags()
end, { desc = "Grapple: Toggle menu" })

-- Atalhos rápidos para pular direto (1 a 4)
for i = 1, 4 do
	vim.keymap.set("n", "<leader>" .. i, function()
		grapple.select({ index = i })
	end, { desc = "Grapple: Go to file " .. i })
end

-- =====================================================
-- Obsidian (bloco único — keymaps duplicados removidos)
-- =====================================================
vim.keymap.set("n", "gf", "<cmd>lua require('obsidian').util.gf_passthrough()<CR>", { desc = "Follow link (gf)" })
vim.keymap.set("n", "<CR>", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Toggle checkbox" })
vim.keymap.set("n", "gx", "<cmd>lua require('obsidian').util.open_in_browser()<CR>", { desc = "Open link in browser" })
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open Obsidian vault" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick switch between notes" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian follow_link<cr>", { desc = "Follow Obsidian link" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>oi", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Open yesterday's note" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian tomorrow<cr>", { desc = "Open tomorrow's note" })
vim.keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>ox", "<cmd>Obsidian link<cr>", { desc = "Insert link" })
vim.keymap.set("n", "<leader>oz", "<cmd>Obsidian link_new<cr>", { desc = "Create and link note" })

-- Undotree embutido no Neovim 0.12 (plugin mbbill/undotree removido)
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Undotree" })

-- =====================================================
-- Gerenciamento de plugins (vim.pack)
-- =====================================================
vim.api.nvim_create_user_command("UpdatePlugins", function()
	vim.pack.update()
	vim.notify("✅ Plugins updated!", vim.log.levels.INFO, { title = "vim.pack" })
end, { desc = "Update all plugins" })

vim.api.nvim_create_user_command("AddPlugin", function(opts)
	if opts.args == "" then
		vim.notify("❌ Please provide a plugin URL", vim.log.levels.ERROR)
		return
	end
	vim.pack.add({ { src = opts.args } })
	vim.notify("➕ Plugin added: " .. opts.args, vim.log.levels.INFO)
end, { desc = "Add a plugin", nargs = 1 })

vim.api.nvim_create_user_command("RemovePlugin", function(opts)
	local name = vim.trim(opts.args)
	if name == "" then
		vim.notify("❌ Por favor, informe o nome do plugin", vim.log.levels.ERROR)
		return
	end

	-- Garante a passagem como tabela { name }
	local ok, err = pcall(vim.pack.del, { name })
	if ok then
		vim.notify("➖ Plugin removido: " .. name, vim.log.levels.INFO)
	else
		vim.notify("❌ Erro ao remover: " .. tostring(err), vim.log.levels.ERROR)
	end
end, { desc = "Remove a plugin", nargs = 1 })

vim.keymap.set("n", "<leader>pu", ":UpdatePlugins<CR>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>pa", ":AddPlugin ", { desc = "Add plugin (enter URL)" })
vim.keymap.set("n", "<leader>pr", ":RemovePlugin ", { desc = "Remove plugin (enter name)" })

-- =====================================================
-- Which-Key
-- =====================================================
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
	{ "<leader>a", group = "harpoon" },

	-- Git (prefixo <leader>g)
	{ "<leader>gc", desc = "commit" },
	{ "<leader>gA", desc = "amend" },
	{ "<leader>gp", desc = "pull" },
	{ "<leader>gd", desc = "preview hunk" },
	{ "<leader>gl", desc = "log commits" },
	{ "<leader>gX", desc = "rebase" },
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
	{ "<leader>gg", desc = "lazygit" },
	{ "<leader>gP", desc = "patch stage" },
	{ "<leader>gR", desc = "git reflog" },
	{ "<leader>co", desc = "diffget local" },
	{ "<leader>ct", desc = "diffget remote" },
	{ "<leader>cb", desc = "diffget base" },
})
