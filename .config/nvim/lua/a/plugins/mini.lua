-- [[ Mini ]]
--  Smart and Powerful commenting plugin for neovim.
-- https://github.com/numToStr/Comment.nvim

return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- https://github.com/echasnovski/mini.ai
      -- require('mini.ai').setup()
      -- https://github.com/echasnovski/mini.comment
      require('mini.comment').setup(
        {
          -- Options which control module behavior
          options = {
            -- Whether to ignore blank lines when adding comment
            ignore_blank_line = false,
            -- Whether to recognize as comment only lines without indent
            start_of_line = false,
            -- Whether to ensure single space pad for comment parts
            pad_comment_parts = true,
          },
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            comment = 'gc',
            -- Toggle comment on current line
            comment_line = 'gcc',
            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            textobject = 'gc',
          },
          -- Hook functions to be executed at certain stage of commenting
          hooks = {
            -- Before successful commenting. Does nothing by default.
            pre = function()
            end,
            -- After successful commenting. Does nothing by default.
            post = function()
            end,
          },
        }
      )
      -- https://github.com/echasnovski/mini.doc
      require('mini.doc').setup()
      -- https://github.com/echasnovski/mini.pairs
      require('mini.pairs').setup()
      -- https://github.com/echasnovski/mini.surround
      require('mini.surround').setup(
        {
          -- Add custom surroundings to be used on top of builtin ones. For more
          -- information with examples, see `:h MiniSurround.config`.
          custom_surroundings = nil,
          -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
          highlight_duration = 500,
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            add = 'sa',            -- Add surrounding in Normal and Visual modes
            delete = 'sd',         -- Delete surrounding
            find = 'sf',           -- Find surrounding (to the right)
            find_left = 'sF',      -- Find surrounding (to the left)
            highlight = 'sh',      -- Highlight surrounding
            replace = 'sr',        -- Replace surrounding
            update_n_lines = 'sn', -- Update `n_lines`
            suffix_last = 'l',     -- Suffix to search with "prev" method
            suffix_next = 'n',     -- Suffix to search with "next" method
          },
          -- Number of lines within which surrounding is searched
          n_lines = 20,
          -- Whether to respect selection type:
          -- - Place surroundings on separate lines in linewise mode.
          -- - Place surroundings on each line in blockwise mode.
          respect_selection_type = false,
          -- How to search for surrounding (first inside current line, then inside
          -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
          -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
          -- see `:h MiniSurround.config`.
          search_method = 'cover',
          -- Whether to disable showing non-error feedback
          silent = false,
        }
      )
      -- https://github.com/echasnovski/mini.move
      require('mini.move').setup(
        {
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-h>',
            right = '<M-l>',
            down = '<M-j>',
            up = '<M-k>',
            -- Move current line in Normal mode
            line_left = '<M-h>',
            line_right = '<M-l>',
            line_down = '<M-j>',
            line_up = '<M-k>',
          },
          -- Options which control moving behavior
          options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
          },
        }
      )
      -- https://github.com/echasnovski/mini.indentscope
      require('mini.indentscope').setup(
        {
          -- Draw options
          draw = {
            -- Delay (in ms) between event and start of drawing scope indicator
            delay = 100,
            -- Symbol priority. Increase to display on top of more symbols.
            priority = 2,
            -- Animation rule for scope's first drawing. A function which, given
            -- next and total step numbers, returns wait time (in ms). See
            -- |MiniIndentscope.gen_animation| for builtin options. To disable
            -- animation, use `require('mini.indentscope').gen_animation.none()`.
            -- animation = --<function: implements constant 20ms between steps>,

          },
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Textobjects
            object_scope = 'ii',
            object_scope_with_border = 'ai',
            -- Motions (jump to respective border line; if not present - body line)
            goto_top = '[i',
            goto_bottom = ']i',
          },
          -- Options which control scope computation
          options = {
            -- Type of scope's border: which line(s) with smaller indent to
            -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
            border = 'both',
            -- Whether to use cursor column when computing reference indent.
            -- Useful to see incremental scopes with horizontal cursor movements.
            indent_at_cursor = true,
            -- Whether to first check input line to be a border of adjacent scope.
            -- Use it if you want to place cursor on function header to get scope of
            -- its body.
            try_as_border = false,
          },
          -- Which character to use for drawing scope indicator
          symbol = '╎',
        }
      )
    end,
  },
}
