-- [[ Lualine ]]
-- A blazing fast and easy to configure Neovim statusline written in Lua.
-- https://github.com/nvim-lualine/lualine.nvim

return {
  {
    event = "VeryLazy",
    "nvim-lualine/lualine.nvim",
    config = function()
      -- import lualine plugin safely
      local status, lualine = pcall(require, "lualine")
      if not status then
        return
      end
      lualine.setup({
        options = {
          theme = "auto",
          sections = {
            lualine_z = {
              function()
                return " " .. os.date("%R")
              end,
            },
          }
        },
      })
    end
    -- opts = {
    --   options = {
    --     theme = "auto",
    --     globalstatus = true,
    --   },
    --   sections = {
    --     lualine_a = { "mode" },
    --     lualine_b = { "branch" },
    --     lualine_c = {
    --       { "diagnostics" },
    --       {
    --         "filetype",
    --         icon_only = true,
    --         separator = "",
    --         padding = { left = 1, right = 0 }
    --       },
    --       {
    --         "filename",
    --         path = 1,
    --         symbols = { modified = "  ", readonly = "", unnamed = "" }
    --       },
    --     },
    --     lualine_x = {
    --       { "diff" },
    --     },
    --     lualine_y = {
    --       {
    --         "progress",
    --         separator = " ",
    --         padding = { left = 1, right = 0 }
    --       },
    --       {
    --         "location",
    --         padding = { left = 0, right = 1 }
    --       },
    --     },
    --     lualine_z = {
    --       function()
    --         return " " .. os.date("%R")
    --       end,
    --     },
    --   },
    --   inactive_sections = {
    --     lualine_a = {},
    --     lualine_v = {},
    --     lualine_y = {},
    --     lualine_z = {},
    --     lualine_c = {},
    --     lualine_x = {},
    --   },
    --   -- extensions = { "neo-tree" },
    -- },
    -- config = function(_, opts)
    --   require("lualine").setup(opts)
    -- end,
  },
}
