-- =====================================================
-- UI: theme, mini.nvim, gitsigns, diffview, conform
-- =====================================================

-- Theme
require("vague").setup({ transparent = true })
vim.cmd.colorscheme("vague")

-- File explorer
require("oil").setup({ view_options = { show_hidden = true } })

-- mini.nvim
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
-- Substitui nvim-web-devicons para telescope e qualquer outro consumidor
require("mini.icons").mock_nvim_web_devicons()
require("mini.statusline").setup({
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 40 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 80 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFiletype", strings = { fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
})

-- Git signs
require("gitsigns").setup({ current_line_blame = true })

-- Indent guides
require("ibl").setup()

-- Images (terminal kitty)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "obsidian" },
	once = true,
	callback = function()
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
	end,
})

-- Diff
require("diffview").setup({
	enhanced_diff_hl = true,
	view = {
		default = { layout = "diff2_horizontal" },
		merge_tool = { layout = "diff3_horizontal" },
	},
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
		markdown = { "prettier" },
	},
	format_on_save = { timeout_ms = 5000 },
})
