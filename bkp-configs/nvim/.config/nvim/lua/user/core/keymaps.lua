-- KEY MAPPINGS
-- set the space as the leader key
vim.g.mapleader = " "
--
local opts = { noremap = true, silent = true }
--
local term_opts = { silent = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- opening a file explore
vim.keymap.set("n", "<leader>e", ":Lex<CR>", opts)

-- save, quit
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>c", ":q<cr>")

-- opening a terminal horizontal window (<C-D> close terminal)
vim.keymap.set("n", "<c-t>", ":split | resize 15 | term<CR> i", opts)

-- openind a terminl in vertical window
vim.keymap.set("n", "<c-p>", ":vert term<CR> i", opts)

-- Esc insert mode and make the terminal scrollable
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", term_opts)

-- moving lines in normal/visual mode
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- navegate beetween windows
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go right window" })
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go down window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go up window" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- buffers
-- vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })

-- Resize with arrows
-- vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
-- vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
-- vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", opts)
-- vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- lazygit
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>")

-- twilight
vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", { noremap = false })

-- zen-mode
vim.keymap.set("n", "zm", ":ZenMode<CR>", opts)

-- Obsidian
vim.keymap.set("n", "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Obsidian Check Checkbox" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })
