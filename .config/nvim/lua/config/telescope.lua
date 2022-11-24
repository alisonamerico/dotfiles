local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup()
local mappings = {
	{ "n", "<Leader>gf", builtin.git_files },
	{ "n", "<Leader>gs", builtin.git_status },
	{ "n", "<Leader>b", builtin.buffers },
	{ "n", "<Leader>o", builtin.oldfiles },
	{ "n", "<Leader>ff", builtin.find_files },
	{ "n", "<Leader>ft", builtin.live_grep },
	{ "n", "<Leader>fb", builtin.buffers },
	{ "n", "<Leader>s", builtin.grep_string },
	{ "n", "<Leader>m", builtin.keymaps },
	{ "n", "<leader>n", telescope.extensions.notify.notify },

}
for _, val in pairs(mappings) do
	vim.keymap.set(unpack(val))
end
