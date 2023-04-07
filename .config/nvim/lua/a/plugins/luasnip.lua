-- [[ LuaSnip ]]
-- Snippet Engine for Neovim written in Lua.
-- https://github.com/L3MON4D3/LuaSnip

return {
  {
    "L3MON4D3/LuaSnip",
    -- version = "<CurrentMajor>.*",    -- follow latest release.
    -- build = "make install_jsregexp", -- install jsregexp (optional!).
    opts = function()
      local types = require("luasnip.util.types")
      return {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " <- Current Choice", "NonTest" } },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local ls = require("luasnip")
      ls.config.set_config(opts)

      -- for _, lang in pairs({ "lua", "go", "sh", "python", "all" }) do
      --   -- ls.add_snippets(lang, require("e.snippets." .. lang), { key = lang })
      -- end
    end,
    keys = {
      {
        "<C-k>",
        function()
          if require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = { "i", "s" },
      },
      {
        "<C-j>",
        function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end,
        mode = { "i", "s" },
      },
      {
        "<C-l>",
        function()
          if require("luasnip").choice_active() then
            require("luasnip").change_choice(1)
          end
        end,
        mode = "i",
      },
      {
        "<C-u>",
        function()
          require("luasnip.extras.select_choice")
        end,
        mode = "i",
      },
    },
  },
}
