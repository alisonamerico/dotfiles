-- =====================================================
-- LSP 100% nativo (Neovim 0.11+/0.12) — sem nvim-lspconfig
-- Cada config é auto-suficiente: cmd, filetypes e root_markers.
-- root_markers é resolvido pelo próprio Neovim via vim.fs.root():
-- ele sobe a árvore a partir do arquivo e usa o primeiro marcador
-- encontrado como workspace root.
-- =====================================================

local servers = {
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".stylua.toml", ".git" },
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	},

	pyright = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
		root_markers = {
			"pyrightconfig.json",
			"pyproject.toml",
			"ruff.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		},
		-- Se precisar de lógica custom de root, use vim.fs.root diretamente:
		-- root_dir = function(bufnr, on_dir)
		--   on_dir(vim.fs.root(bufnr, { "pyrightconfig.json", "pyproject.toml", ".git" }))
		-- end,
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
	},

	-- Nota: ruff NÃO é LSP aqui de propósito — formatação/lint rodam via
	-- conform (ruff_fix/ruff_format) e análise de tipos via pyright.

	taplo = {
		cmd = { "taplo", "lsp", "stdio" },
		filetypes = { "toml" },
		root_markers = { "taplo.toml", ".git" },
	},

	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "htmldjango", "djangohtml" },
		root_markers = { "package.json", ".git" },
	},

	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
	},

	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	},

	jsonls = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { ".git" },
	},

	marksman = {
		cmd = { "marksman" },
		filetypes = { "markdown", "obsidian" },
		root_markers = { ".marksman.toml", ".git" },
	},
}

for name, cfg in pairs(servers) do
	vim.lsp.config(name, cfg)
end

-- Mason: apenas instala/atualiza os binários (o Neovim não tem instalador
-- nativo de language servers). As configs vêm do bloco acima.
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = false, -- habilitamos manualmente abaixo, com nossas configs
})

vim.lsp.enable(vim.tbl_keys(servers))

-- Atalhos ativos apenas quando um LSP é anexado ao buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "<leader>lf", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, vim.tbl_extend("force", opts, { desc = "Format file" }))

		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code actions" })
		)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
		vim.keymap.set(
			"n",
			"gD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to Declaration" })
		)
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to Implementation" })
		)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
	end,
})

-- =====================================================
-- Comandos :Lsp* — substitutos nativos do nvim-lspconfig
-- (:LspInfo/:LspStart/:LspStop/:LspRestart)
-- =====================================================

-- Resolve os nomes passados; sem argumentos, usa os clients ativos do buffer.
local function lsp_names_from_args(args, bufnr)
	if #args > 0 then
		return args
	end
	local names = {}
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		names[#names + 1] = c.name
	end
	return names
end

vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify(string.format("Nenhum client LSP ativo no buffer (filetype=%s)", vim.bo.filetype))
		return
	end
	for _, c in ipairs(clients) do
		local comp = c:supports_method("textDocument/completion") and "completion: ativa" or "sem completion"
		vim.notify(string.format("%s | root=%s | %s", c.name, tostring(c.config.root_dir), comp))
	end
end, { desc = "Lista os clients LSP ativos no buffer atual" })

vim.api.nvim_create_user_command("LspStart", function(info)
	local ft = vim.bo.filetype
	local names = info.fargs
	if #names == 0 then
		for name, cfg in pairs(servers) do
			if cfg.filetypes and vim.tbl_contains(cfg.filetypes, ft) then
				names[#names + 1] = name
			end
		end
		if #names == 0 then
			vim.notify(string.format("Nenhum servidor configurado para o filetype '%s'", ft))
			return
		end
	end
	for _, name in ipairs(names) do
		if servers[name] then
			vim.lsp.enable(name)
		end
	end
end, { nargs = "*", desc = "Habilita/sobe os servidores (default: os do filetype atual)" })

vim.api.nvim_create_user_command("LspStop", function(info)
	local names = lsp_names_from_args(info.fargs, vim.api.nvim_get_current_buf())
	for _, name in ipairs(names) do
		if vim.lsp.config[name] ~= nil then
			vim.lsp.enable(name, false)
			if info.bang then
				vim.iter(vim.lsp.get_clients({ name = name })):each(function(c)
					c:stop(true)
				end)
			end
		end
	end
end, { nargs = "*", bang = true, desc = "Desabilita/para os clients (com ! força)" })

vim.api.nvim_create_user_command("LspRestart", function(info)
	local names = lsp_names_from_args(info.fargs, vim.api.nvim_get_current_buf())
	for _, name in ipairs(names) do
		if vim.lsp.config[name] ~= nil then
			vim.lsp.enable(name, false)
			if info.bang then
				vim.iter(vim.lsp.get_clients({ name = name })):each(function(c)
					c:stop(true)
				end)
			end
		end
	end
	vim.defer_fn(function()
		for _, name in ipairs(names) do
			if vim.lsp.config[name] ~= nil then
				vim.lsp.enable(name)
			end
		end
	end, 300)
end, { nargs = "*", bang = true, desc = "Reinicia os clients (default: os do buffer atual)" })
