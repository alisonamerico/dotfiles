-- [[ Theme ]]
-- Neovim theme based off of the Nord Color Palette.
-- https://github.com/shaunsingh/nord.nvim

return {
  -- nord theme
  {
    "shaunsingh/nord.nvim",
    opts = {
      colorscheme = "nord",
    },
    config = function()
      require('nord').set()
    end,
  },
}
