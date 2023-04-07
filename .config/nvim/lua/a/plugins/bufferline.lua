-- [[ Bufferline ]]
-- A snazzy nail_care buffer line (with tabpage integration)
-- for Neovim built using lua.
-- https://github.com/akinsho/bufferline.nvim

return {
  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    priority = 999,
    version = "v3.*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        separator_style = "slant",
        always_show_bufferline = false,
      },
    },
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
    keys = {
      {
        "<leader>z",
        function()
          require("bufferline").cycle(-1)
        end,
      }, -- move to the previous buffer
      {
        "<leader>x",
        function()
          require("bufferline").cycle(1)
        end,
      }, -- move to the next buffer
    },
  },
}
