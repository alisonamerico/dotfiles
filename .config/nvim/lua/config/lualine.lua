require("lualine").setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		theme = "nordfox",
		section_separators = { left = '', right = ''},
			component_separators = { "", "" },
		always_divide_middle = true,
	  },
	  sections = {
		lualine_a = { "mode" },
		lualine_b = {"branch"},
		lualine_c = { "diagnostics" },
		lualine_x = { "diff", "spaces", "encoding", "filetype" },
		lualine_y = { "location" },
		lualine_z = { "progress" },
	  },

})

