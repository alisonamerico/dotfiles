-- return {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     config = function()
--         local config = require("nvim-treesitter.configs")
--         config.setup({
--             ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "json", "yaml", "css", "markdown", "markdown_inline", "dockerfile", "gitignore" "html", "htmldjango", "javascript", "query" },
--             auto_install = true,
--             highlight = { enable = true },
--             indent = { enable = true },
--             incremental_selection = {
--                 enable = true,
--                 keymaps = {
--                     init_selection = "<Enter>", -- set to `false` to disable one of the mappings
--                     node_incremental = "<Enter>",
--                     scope_incremental = false,
--                     node_decremental = "<Backspace>",
--                 },
--             },
--         })
--
--         -- Make sure HTML syntax highlighting extends to htmldjango files
--         vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--             pattern = "*.html",
--             callback = function()
--                 if vim.fn.search("{% .* %}", "nw") > 0 or vim.fn.search("{{ .* }}", "nw") > 0 then
--                     vim.bo.filetype = "htmldjango"
--                 end
--             end,
--         })
--
--         -- Enhanced Django template tag highlighting
--         vim.api.nvim_create_autocmd("FileType", {
--             pattern = "htmldjango",
--             callback = function()
--                 vim.cmd([[
--                     syntax match djangoStatement "{%" containedin=ALL
--                     syntax match djangoStatement "%}" containedin=ALL
--                     syntax match djangoVarBlock "{{" containedin=ALL
--                     syntax match djangoVarBlock "}}" containedin=ALL
--                     highlight djangoStatement ctermfg=127 guifg=#af00af
--                     highlight djangoVarBlock ctermfg=72 guifg=#5faf87
--                 ]])
--             end,
--         })
--     end,
-- }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
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
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "python",
          "json",
          "yaml",
          "css",
          "markdown",
          "markdown_inline",
          "dockerfile",
          "gitignore",
          "html",
          -- "htmldjango",
          "javascript",
          "jinja",
          "query",
        },
        -- auto install above language parsers
        auto_install = false,
      })
    end,
  },
}
