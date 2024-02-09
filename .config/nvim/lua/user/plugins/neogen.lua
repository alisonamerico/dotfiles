-- [[ Neogen ]]
-- Your Annotation Toolkit
-- https://github.com/danymat/neogen

return {
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings"
            }
          },
        }
      })
    end
  }
}
