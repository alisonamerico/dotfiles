return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  -- config = function()
  --   -- require("telescope").setup({})
  --   local telescope = require("telescope.builtin")
  --   -- telescope.load_extension('fzf')
  --   -- vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
  --   -- vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
  --   vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
  --   vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
  --   vim.keymap.set("n", "<leader>/", function()
  --     -- You can pass additional configuration to builtin to change the theme, layout, etc.
  --     telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
  --       winblend = 10,
  --       previewer = false,
  --     }))
  --   end, { desc = "[/] Fuzzily search in current buffer" })
  -- end,
}
