-- [[ Setting options ]]
-- See `:help vim.o`

--[[ opts.lua ]]

local g = vim.g
g.t_co = 256
g.background = 'dark'
g.border_style = "rounded"
local opt = vim.opt


-- [[ Context ]]
opt.autoindent = true -- bool: Show the automatically identified lines
opt.autoread = true -- bool: Detects changes automatically made
opt.clipboard = 'unnamedplus' -- str: This option is a list of comma-separated names
opt.colorcolumn = '80,88,120' -- str:  Show col for max line length
opt.cursorline = true -- bool: Highlight the text line of the cursor
opt.foldenable = false
opt.hidden = true
opt.mouse = "a" -- Enable mouse mode
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 5 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column
opt.shell = "/bin/bash"
opt.wildignore = "*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite"
opt.laststatus = 3
opt.completeopt = 'menuone,noinsert,noselect' -- Set completeopt to have a better completion experience
opt.breakindent = true -- bool: Enable break indent
opt.updatetime = 250 -- int: Decrease update time
opt.list = true  -- Show some invisible characters
opt.sidescrolloff = 8 -- columns of context
opt.wildmode = {'list', 'longest'}  -- command-line completion mode
opt.wrap = false -- display lines as one long line

-- [[ Filetypes ]]
opt.encoding = 'utf8' -- str:  String encoding to use
opt.fileencoding = 'utf8' -- str:  File encoding to use
opt.undofile = true -- bool: Save undo history

-- [[ Theme ]]
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable
vim.cmd [[colorscheme nord]] -- vim.cmd [[colorscheme nord]]


-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = false -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for
opt.smartindent = true

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one




-- local options = {
--   colorcolumn = '80,88,120',               -- str:  Show col for max line length
--   backup = false,                          -- creates a backup file
--   clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
--   cmdheight = 2,                           -- more space in the neovim command line for displaying messages
--   completeopt = { "menuone", "noselect" }, -- mostly just for cmp
--   conceallevel = 0,                        -- so that `` is visible in markdown files
--   fileencoding = "utf-8",                  -- the encoding written to a file
--   hlsearch = true,                         -- highlight all matches on previous search pattern
--   ignorecase = true,                       -- ignore case in search patterns
--   mouse = "a",                             -- allow the mouse to be used in neovim
--   pumheight = 10,                          -- pop up menu height
--   showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
--   showtabline = 2,                         -- always show tabs
--   smartcase = true,                        -- smart case
--   smartindent = true,                      -- make indenting smarter again
--   splitbelow = true,                       -- force all horizontal splits to go below current window
--   splitright = true,                       -- force all vertical splits to go to the right of current window
--   swapfile = false,                        -- creates a swapfile
--   termguicolors = true,                    -- set term gui colors (most terminals support this)
--   timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
--   undofile = true,                         -- enable persistent undo
--   updatetime = 300,                        -- faster completion (4000ms default)
--   writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
--   expandtab = true,                        -- convert tabs to spaces
--   shiftwidth = 2,                          -- the number of spaces inserted for each indentation
--   tabstop = 2,                             -- insert 2 spaces for a tab
--   cursorline = true,                       -- highlight the current line
--   number = true,                           -- set numbered lines
--   relativenumber = false,                  -- set relative numbered lines
--   numberwidth = 4,                         -- set number column width to 2 {default 4}

--   signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
--   wrap = true,                             -- display lines as one long line
--   linebreak = true,                        -- companion to wrap, don't split words
--   scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
--   sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
--   guifont = "monospace:h17",               -- the font used in graphical neovim applications
--   whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line
--   syntax = "ON", -- str:  Allow syntax highlighting

-- }

-- for k, v in pairs(options) do
--   vim.opt[k] = v
-- end

-- -- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
-- vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
-- vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
-- vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
-- vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use
-- vim.cmd [[colorscheme nord]] -- vim.cmd [[colorscheme nord]]
