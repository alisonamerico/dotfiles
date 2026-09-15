-- =====================================================
-- Plugin Manager (vim.pack — nativo do Neovim 0.12)
-- =====================================================
vim.pack.add({
	-- Theme
	{ src = "https://github.com/vague-theme/vague.nvim" },

	-- Core
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },

	-- LSP (instalador; as configs são 100% nativas em lua/lsp.lua)
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },

	-- Utils
	{ src = "https://github.com/cbochs/grapple.nvim" },
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
	{ src = "https://github.com/3rd/image.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
})
-- Removidos e POR QUE:
--   nvim-lspconfig    -> configs nativas (cmd/filetypes/root_markers em lsp.lua)
--   nvim-cmp/cmp-nvim-lsp/LuaSnip/friendly-snippets -> vim.lsp.completion + vim.snippet
--   nvim-web-devicons -> mini.icons (mock em ui.lua)
--   undotree          -> :Undotree embutido no Neovim 0.12
--   nvim-tmux-navigation -> navegação movida para o ~/.tmux.conf
--   lazygit.nvim      -> :terminal lazygit (ver keymaps.lua)
--   avante.nvim/nui.nvim -> removidos na migração

-- Substituido Harppon por Grapple
