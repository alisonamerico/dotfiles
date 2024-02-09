-- [[ Bufferline ]]
-- A Neovim bufferline for people with addictive personalities
-- https://github.com/willothy/nvim-cokeline

return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {
        options = {
          -- mode = "tab",
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
          offset = {
            -- filetype = "coc-explorer",
            text = "File Explorer",
            highlight = "Directory",
            separator_style = "slant",
            text_align = "left"
          }
        },
      }
    end
  }
}
