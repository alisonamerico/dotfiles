-- [[ Cokeline ]]
-- A Neovim bufferline for people with addictive personalities
-- https://github.com/willothy/nvim-cokeline

return {
  {
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- File icons
    },
    config = function()
      local get_hex = require('cokeline/utils').get_hex

      -- local green = vim.g.terminal_color_2
      -- local yellow = vim.g.terminal_color_3

      require('cokeline').setup({
        default_hl = {
          fg = function(buffer)
            return
                buffer.is_focused
                and get_hex('Normal', 'fg')
                or get_hex('Comment', 'fg')
          end,
          bg = get_hex('ColorColumn', 'bg'),
        },

        components = {
          {
            text = '｜',
          },
          {
            text = function(buffer) return buffer.devicon.icon .. '' end,
            fg = function(buffer) return buffer.devicon.color end,
          },
          {
            text = function(buffer) return buffer.index .. ': ' end,
          },
          {
            text = function(buffer) return buffer.unique_prefix end,
            fg = get_hex('Comment', 'fg'),
            style = 'italic',
          },
          {
            text = function(buffer) return buffer.filename .. ' ' end,
            style = function(buffer) return buffer.is_focused and 'bold' or nil end,
          },
          {
            text = ' ',
          },
        },
      })
    end
  }
}
