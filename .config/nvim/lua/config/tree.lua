vim.g.nvim_tree_width = 36
vim.g.nvim_tree_width_allow_resize = 1

require("nvim-tree").setup({
	renderer = {
		highlight_opened_files = 'all',
		add_trailing = true,
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filters = {
		dotfiles = true,
        exclude = {"config/", ".env", "app.log"},
		custom = {
			[[\.pyc$]],
			"__pycache__",
			".git",
			".DS_Store",
			".ropeproject",
			".coverage",
			"cover/",
		},
	},
})

vim.keymap.set("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>")
