-- [[ Treesitter ]]
-- Provide highlight, edit, and navigate code.
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
}