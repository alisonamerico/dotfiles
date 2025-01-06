-- return {
--     "beauwilliams/statusline.lua",
--     dependencies = { "nvim-tree/nvim-web-devicons" },
--     config = function()
--         local statusline = require('statusline')
--         statusline.tabline = false
--         statusline.lsp_diagnostics = true
--     end,
-- }
-- return {
--   "echasnovski/mini.statusline",
--   dependencies = { "nvim-tree/nvim-web-devicons" },
--   config = function()
--     require("mini.statusline").setup({ set_vim_settings = false })
--   end,
-- }

return {
  "nvim-lualine/lualine.nvim",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {
          'mode',
        },
        lualine_b = {
          'branch'
        },
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
            -- 'windows'
          }
        },
        lualine_x = {},
      }
    })
  end,
}
