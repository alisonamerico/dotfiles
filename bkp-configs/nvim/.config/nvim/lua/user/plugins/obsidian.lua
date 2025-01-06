return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "/home/alison/obsidian-notes/notes",
      },
    },
    templates = {
      folder = "templates",
    },
    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url }) -- linux
    end,
  },
}
