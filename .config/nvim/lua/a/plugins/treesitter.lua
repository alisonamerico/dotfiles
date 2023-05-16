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
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
      -- import nvim-treesitter plugin safely
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status then
        return
      end

      -- configure treesitter
      treesitter.setup({
        -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "css",
          "scss",
          "python",
          "http",
          "regex",
          "json",
          "javascript",
          "typescript",
          "tsx",
          "toml",
          "yaml",
          "html",
          "css",
          "markdown",
          "bash",
          "lua",
          "vimdoc",
          "vim",
          "dockerfile",
          "gitignore",
        },
        -- auto install above language parsers
        auto_install = true,
      })
    end,
  },
}
