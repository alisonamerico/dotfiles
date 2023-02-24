
-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
    options = {
        globalstatus = true,
        icons_enabled = true,
        -- theme = "onedark",
        theme = "nord",
        section_separators = { left = '', right = '' },
        component_separators = { "", "" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "diagnostics" },
        lualine_x = { "diff", "spaces", "encoding", "filetype" },
        lualine_y = { "location" },
        lualine_z = { "progress" },
    },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Close autopairs
require("nvim-autopairs").setup {}

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
    
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
    
        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})
    
        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
    
        -- ACTIONS

        -- Jump between hunks
        -- map('n', '<leader>gp', gs.prev_hunk, {desc = '[g]it [p]rev'})
        -- map('n', '<leader>gn', gs.next_hunk, {desc = '[g]it [n]ext'})

        -- Popup what's changed in a hunk under cursor
        map('n', '<leader>gpr', gs.preview_hunk, {desc = '[g]it [pr]eview'})

        -- Stage/reset individual hunks under cursor in a file
        map({'n', 'v'}, '<leader>gsi', ':Gitsigns stage_hunk<CR>', {desc = '[g]it [s]age [i]ndividual'})
        map({'n', 'v'}, '<leader>gri', ':Gitsigns reset_hunk<CR>', {desc = '[g]it [r]eset [i]ndividual'})
        map('n', '<leader>gu', gs.undo_stage_hunk, {desc = '[g]it [u]ndo Stage'})

        -- Stage/reset all hunks in a file
        map('n', '<leader>gsa', gs.stage_buffer, {desc = '[g]it [s]tage [a]ll files'})
        map('n', '<leader>gra', gs.reset_buffer, {desc = '[g]it [r]eset [a]ll files'})
        -- map('n', '<leader>gri', gs.reset_buffer_index, {desc = '[g]it [r]eset [i]ndex'})


        map('n', '<leader>gb', function() gs.blame_line{full=true} end, {desc = '[g]it [b]lame'})
        map('n', '<leader>gbc', gs.toggle_current_line_blame, {desc = '[t]oogle [b]lame (current line)'})
        map('n', '<leader>gd', gs.diffthis, {desc = '[g]it [d]iff'})
        map('n', '<leader>gD', function() gs.diffthis('~') end, {desc = '[g]it [D]iff'})
        map('n', '<leader>td', gs.toggle_deleted, {desc = '[t]oogle [d]elet'})
 
        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = 'Select Hunt'})
      end
    -- signs = {
    --     add = { text = '+' },
    --     change = { text = '~' },
    --     delete = { text = '_' },
    --     topdelete = { text = '‾' },
    --     changedelete = { text = '~' },
    -- },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'vim' },

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}


local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- local sources = { null_ls.builtins.code_actions.gitsigns }

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup {
  debug = false,
  sources = {
    -- formatting
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
    formatting.djlint,
    formatting.isort,
    -- formatting.isort.with { args = { "--force-grid-wrap 3", } },
    formatting.lua_format,
    formatting.prettierd,

    -- diagnostics
    -- diagnostics.flake8,
    diagnostics.write_good,
    diagnostics.djlint,
    -- diagnostics.stylelint,
  },
}


-- LSP settings.
-- --  This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr)
--     -- NOTE: Remember that lua is a real programming language, and as such it is possible
--     -- to define small helper and utility functions so you don't have to repeat yourself
--     -- many times.
--     --
--     -- In this case, we create a function that lets us more easily define mappings specific
--     -- for LSP related items. It sets the mode, buffer and description for us each time.
--     local nmap = function(keys, func, desc)
--         if desc then
--             desc = 'LSP: ' .. desc
--         end

--         vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--     end

--     nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--     nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

--     nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--     nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--     nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--     nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--     nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--     nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

--     -- See `:help K` for why this keymap
--     nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--     nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

--     -- Lesser used LSP functionality
--     nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--     nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--     nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--     nmap('<leader>wl', function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, '[W]orkspace [L]ist Folders')

--     -- Create a command `:Format` local to the LSP buffer
--     vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--         vim.lsp.buf.format('black')
--     end, { desc = 'Format current buffer with LSP' })
-- end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- pylsp = {
    --     pylsp = {
    --         plugins = {
    --           pycodestyle = {
    --             --ignore = {'W391'},
    --             --maxLineLength = 100
    --           }
    --         }
    --     }
    --   },

    -- sumneko_lua = {
    --     Lua = {
    --         workspace = { checkThirdParty = false },
    --         telemetry = { enable = false },
    --     },
    -- },
}

-- Setup neovim lua configuration
require('neodev').setup{}
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- Tree
vim.g.nvim_tree_width = 36
vim.g.nvim_tree_width_allow_resize = 1

require("nvim-tree").setup({
	renderer = {
		highlight_opened_files = 'all',
		add_trailing = true,
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filters = {
		dotfiles = true,
        exclude = {"config/", ".env", "app.log"},
		custom = {
			[[\.pyc$]],
			"__pycache__",
			".git",
			".DS_Store",
			".ropeproject",
			".coverage",
			"cover/",
		},
	},
})
-- -- Load the colorscheme
require('nord').set()

local highlights = require("nord").bufferline.highlights({
    italic = true,
    bold = true,
})

require("bufferline").setup({
    options = {
        separator_style = "thin",
    },
    highlights = highlights,
})


-- See: https://github.com/neovim/nvim-lspconfig/tree/54eb2a070a4f389b1be0f98070f81d23e2b1a715#suggested-configuration
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gdc', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gdf', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
require('lspconfig').ruff_lsp.setup {
  on_attach = on_attach,
}


-- Lua
local actions = require("diffview.actions")

require("diffview").setup({
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" },      -- The git executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  show_help_hints = true,   -- Show hints for how to open the help panel
  watch_index = true,       -- Update views and index buffers when the git index changes.
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see ':h diffview-config-view.x.layout'.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
      winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
      winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
    },
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
      win_opts = {}
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
      hg = {
        single_file = {},
        multi_file = {},
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
      win_opts = {}
    },
  },
  commit_log_panel = {
    win_config = {   -- See ':h diffview-config-win_config'
      win_opts = {},
    }
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      { "n", "<tab>",      actions.select_next_entry,          { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",    actions.select_prev_entry,          { desc = "Open the diff for the previous file" } },
      { "n", "gf",         actions.goto_file,                  { desc = "Open the file in a new split in the previous tabpage" } },
      { "n", "<C-w><C-f>", actions.goto_file_split,            { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",    actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e",  actions.focus_files,                { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",  actions.toggle_files,               { desc = "Toggle the file panel." } },
      { "n", "g<C-x>",     actions.cycle_layout,               { desc = "Cycle through available layouts." } },
      { "n", "[x",         actions.prev_conflict,              { desc = "In the merge-tool: jump to the previous conflict" } },
      { "n", "]x",         actions.next_conflict,              { desc = "In the merge-tool: jump to the next conflict" } },
      { "n", "<leader>co", actions.conflict_choose("ours"),    { desc = "Choose the OURS version of a conflict" } },
      { "n", "<leader>ct", actions.conflict_choose("theirs"),  { desc = "Choose the THEIRS version of a conflict" } },
      { "n", "<leader>cb", actions.conflict_choose("base"),    { desc = "Choose the BASE version of a conflict" } },
      { "n", "<leader>ca", actions.conflict_choose("all"),     { desc = "Choose all the versions of a conflict" } },
      { "n", "dx",         actions.conflict_choose("none"),    { desc = "Delete the conflict region" } },
    },
    diff1 = {
      -- Mappings in single window diff layouts
      { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
    },
    diff2 = {
      -- Mappings in 2-way diff layouts
      { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
    },
    diff3 = {
      -- Mappings in 3-way diff layouts
      { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
      { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
      { "n",          "g?",   actions.help({ "view", "diff3" }),  { desc = "Open the help panel" } },
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      { { "n", "x" }, "1do",  actions.diffget("base"),            { desc = "Obtain the diff hunk from the BASE version of the file" } },
      { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
      { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
      { "n",          "g?",   actions.help({ "view", "diff4" }),  { desc = "Open the help panel" } },
    },
    file_panel = {
      { "n", "j",             actions.next_entry,           { desc = "Bring the cursor to the next file entry" } },
      { "n", "<down>",        actions.next_entry,           { desc = "Bring the cursor to the next file entry" } },
      { "n", "k",             actions.prev_entry,           { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<up>",          actions.prev_entry,           { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<cr>",          actions.select_entry,         { desc = "Open the diff for the selected entry." } },
      { "n", "o",             actions.select_entry,         { desc = "Open the diff for the selected entry." } },
      { "n", "<2-LeftMouse>", actions.select_entry,         { desc = "Open the diff for the selected entry." } },
      { "n", "-",             actions.toggle_stage_entry,   { desc = "Stage / unstage the selected entry." } },
      { "n", "S",             actions.stage_all,            { desc = "Stage all entries." } },
      { "n", "U",             actions.unstage_all,          { desc = "Unstage all entries." } },
      { "n", "X",             actions.restore_entry,        { desc = "Restore entry to the state on the left side." } },
      { "n", "L",             actions.open_commit_log,      { desc = "Open the commit log panel." } },
      { "n", "<c-b>",         actions.scroll_view(-0.25),   { desc = "Scroll the view up" } },
      { "n", "<c-f>",         actions.scroll_view(0.25),    { desc = "Scroll the view down" } },
      { "n", "<tab>",         actions.select_next_entry,    { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",       actions.select_prev_entry,    { desc = "Open the diff for the previous file" } },
      { "n", "gf",            actions.goto_file,            { desc = "Open the file in a new split in the previous tabpage" } },
      { "n", "<C-w><C-f>",    actions.goto_file_split,      { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",       actions.goto_file_tab,        { desc = "Open the file in a new tabpage" } },
      { "n", "i",             actions.listing_style,        { desc = "Toggle between 'list' and 'tree' views" } },
      { "n", "f",             actions.toggle_flatten_dirs,  { desc = "Flatten empty subdirectories in tree listing style." } },
      { "n", "R",             actions.refresh_files,        { desc = "Update stats and entries in the file list." } },
      { "n", "<leader>e",     actions.focus_files,          { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",     actions.toggle_files,         { desc = "Toggle the file panel" } },
      { "n", "g<C-x>",        actions.cycle_layout,         { desc = "Cycle available layouts" } },
      { "n", "[x",            actions.prev_conflict,        { desc = "Go to the previous conflict" } },
      { "n", "]x",            actions.next_conflict,        { desc = "Go to the next conflict" } },
      { "n", "g?",            actions.help("file_panel"),   { desc = "Open the help panel" } },
    },
    file_history_panel = {
      { "n", "g!",            actions.options,                     { desc = "Open the option panel" } },
      { "n", "<C-A-d>",       actions.open_in_diffview,            { desc = "Open the entry under the cursor in a diffview" } },
      { "n", "y",             actions.copy_hash,                   { desc = "Copy the commit hash of the entry under the cursor" } },
      { "n", "L",             actions.open_commit_log,             { desc = "Show commit details" } },
      { "n", "zR",            actions.open_all_folds,              { desc = "Expand all folds" } },
      { "n", "zM",            actions.close_all_folds,             { desc = "Collapse all folds" } },
      { "n", "j",             actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
      { "n", "<down>",        actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
      { "n", "k",             actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<up>",          actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<cr>",          actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "o",             actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "<2-LeftMouse>", actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "<c-b>",         actions.scroll_view(-0.25),          { desc = "Scroll the view up" } },
      { "n", "<c-f>",         actions.scroll_view(0.25),           { desc = "Scroll the view down" } },
      { "n", "<tab>",         actions.select_next_entry,           { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",       actions.select_prev_entry,           { desc = "Open the diff for the previous file" } },
      { "n", "gf",            actions.goto_file,                   { desc = "Open the file in a new split in the previous tabpage" } },
      { "n", "<C-w><C-f>",    actions.goto_file_split,             { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",       actions.goto_file_tab,               { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e",     actions.focus_files,                 { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",     actions.toggle_files,                { desc = "Toggle the file panel" } },
      { "n", "g<C-x>",        actions.cycle_layout,                { desc = "Cycle available layouts" } },
      { "n", "g?",            actions.help("file_history_panel"),  { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<tab>", actions.select_entry,          { desc = "Change the current option" } },
      { "n", "q",     actions.close,                 { desc = "Close the panel" } },
      { "n", "g?",    actions.help("option_panel"),  { desc = "Open the help panel" } },
    },
    help_panel = {
      { "n", "q",     actions.close,  { desc = "Close help menu" } },
      { "n", "<esc>", actions.close,  { desc = "Close help menu" } },
    },
  },
})