-- OPTIONS
-- for conciseness
local opt = vim.opt


--opt.winbar="%=%m %f"  --or winbar=%f
opt.laststatus = 3
opt.syntax = "on"                                   -- set syntax to be loaded for current
opt.termguicolors = true                            -- set term gui colors (most terminals support this)
opt.title = true                                    -- set name the current window
opt.number = true                                   -- set numbered lines
opt.relativenumber = true                           -- set relative numbered lines
opt.cursorline = true                               -- set highlight the screen line of the cursor
opt.colorcolumn = "80"                              -- set columns to highlight
opt.confirm = true                                  -- ask what to do about unsaved/read-only files
opt.fileencoding = "utf-8"                          -- the encoding written to a file
opt.clipboard = "unnamed,unnamedplus"               -- allows neovim to access the system clipboard
opt.splitbelow = true                               -- force all horizontal splits to go below current window
opt.splitright = true                               -- force all vertical splits to go to the right of current window
opt.hidden = true                                   -- required to keep multiple buffers and open multiple buffers
opt.scrolloff = 2                                   -- set minimum nr. of lines above and below cursor
opt.smartcase = true                                -- smart case
opt.smartindent = true                              -- set smart autoindenting when starting a new line
opt.ignorecase = true                               -- ignore case in search patterns
opt.expandtab = true                                -- convert tabs to spaces
opt.tabstop = 4                                     -- insert 4 spaces for a tab
opt.softtabstop = 4                                 -- set number of spaces that a <Tab> counts for while performing editing operations
opt.shiftwidth = 4                                  -- set number of spaces to use for each step of (auto)indent
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.swapfile = false                                -- creates a swapfile
opt.backup = false                                  -- creates a backup file
opt.undofile = true                                 -- enable persistent undo
opt.wrap = false                                    -- display lines as one long line
opt.wildmode = { "longest", "full" }                -- enables the autofill menu when you press TAB
opt.conceallevel=2                                  -- concealer for Neorg, Obsidian

-- NETRW BROWSER SETTINGS
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

-- NETRW File operations

-- p: Opens a preview window.

-- <C-w>z: Ctrl + w and then z. Closes the preview window.

-- gh: Toggles the hidden files.

-- %: Creates a file. Well... it actually doesn't, it just gives you the opportunity to create one. When you press % vim will ask the name you want to give the file and then it lets you edit it. After entering the name you have to save the file (using :write) to create it.

-- R: Renames a file

-- mt: Assign the "target directory" used by the move and copy commands.

-- mf: Marks a file or directory. Any action that can be performed on multiple files depend on these marks. So if you want to copy, move or delete files, you need to mark them.

-- mc: Copy the marked files in the target directory.

-- mm: Move the marked files to the target directory.

-- mx: Runs an external command on the marked files.

-- D: Deletes a file or an empty directory. vim will not let us delete a non-empty directory. I'll show how to bypass this later on.

-- d: Creates a directory.
