-- [[ Telescope ]]
-- telescope.nvim is a highly extendable fuzzy finder over lists.
-- Built on the latest awesome features from neovim core.
-- Telescope is centered around modularity, allowing for easy customization.
-- https://github.com/nvim-telescope/telescope.nvim

local function get_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  path = path and vim.fs.dirname(path) or vim.loop.cwd()
  local root = vim.fs.find({ ".git", "/lua" }, { path = path, upward = true })[1]
  root = root and vim.fs.dirname(root) or vim.loop.cwd()
  return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local function telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    config = function(_, opts)
      local t = require("telescope")
      t.setup(opts)
      t.load_extension("fzf")
    end,
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>fg", telescope("live_grep") },
      { "<leader>ff", telescope("files") },
      { "<leader>fb", telescope("current_buffer_fuzzy_find"), desc = "Current Buffer" },
      { "<leader>fc", telescope("command_history"),           desc = "Command History" },
      { "<leader>fC", telescope("commands"),                  desc = "Commands" },
      {
        "<leader>H",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
    },
  },
}