require("nightfox").setup({
	integrations = {
		cmp = true,
		gitsigns = true,
		lsp_trouble = true,
		mason = true,
		neogit = true,
		notify = true,
		nvimtree = true,
		pounce = true,
		telescope = true,
		treesitter = true,
		treesitter_context = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
	},
	options = {
		styles = {
		  comments = "italic",
		  keywords = "bold",
		  types = "italic,bold",
		}
	  },
})
vim.cmd("colorscheme nordfox")