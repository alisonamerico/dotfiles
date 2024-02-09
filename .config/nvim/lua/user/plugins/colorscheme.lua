return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },
  -- Remove all background colors to make nvim transparent.
  { "xiyaowong/transparent.nvim" }
}
