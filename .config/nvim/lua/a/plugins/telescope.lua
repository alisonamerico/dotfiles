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
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim", run = "make",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- File icons
    },
    config = function()
      -- import telescope plugin safely
      local telescope_setup, telescope = pcall(require, "telescope")
      if not telescope_setup then
        return
      end

      -- import telescope actions safely
      local actions_setup, actions = pcall(require, "telescope.actions")
      if not actions_setup then
        return
      end

      -- configure telescope
      telescope.setup({
        -- configure custom mappings
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,                 -- move to prev result
              ["<C-j>"] = actions.move_selection_next,                     -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
            },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
