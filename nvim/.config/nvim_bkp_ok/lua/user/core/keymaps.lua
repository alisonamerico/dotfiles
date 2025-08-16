-- KEY MAPPINGS
-- set the space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local map = vim.keymap
local opts = { noremap = true, silent = true }
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Disable the spacebar key's default behavior in Normal and Visual modes
map.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Allow moving the cursor through wrapped lines with j, k
map.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- clear highlights
map.set("n", "<Esc>", ":noh<CR>", opts)

-- save file
map.set("n", "<leader>w", ":w<cr>")
-- map.set("n", "<leader>w", function()
--     require("conform").format({
--         lsp_format = "fallback",
--     })
-- end, { desc = "Format current file" })

-- quit file
map.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- delete single character without copying into register
map.set("n", "x", '"_x', opts)

-- Vertical scroll and center
map.set("n", "<C-d>", "<C-d>zz", opts)
map.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
map.set("n", "n", "nzzzv")
map.set("n", "N", "Nzzzv")

-- Press jk fast to exit insert mode
map.set("i", "jk", "<ESC>", opts)
map.set("i", "kj", "<ESC>", opts)

-- MY PREVIOUS CONFIG

-- moving lines in normal/visual mode
-- Move the current line up and down in Normal mode
map.set("n", "<A-k>", ":m .-2<CR>==", opts) -- Move current line up
map.set("n", "<A-j>", ":m .+1<CR>==", opts) -- Move current line down

-- Move selected lines up and down in Visual mode
map.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts) -- Move selected lines down
map.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts) -- Move selected lines up

-- Indent and unindent in Normal mode
map.set("n", "<A-l>", ">>", opts) -- Indent current line right
map.set("n", "<A-h>", "<<", opts) -- Unindent current line left

-- Indent and unindent in Visual mode
map.set("v", "<A-l>", ">gv", opts) -- Indent selected lines right
map.set("v", "<A-h>", "<gv", opts) -- Unindent selected lines left

-- Custom key mappings for folding
-- map.set("n", "<leader>zM", "zM", opts, {desc = "Close all folds"})
-- map.set("n", "<leader>zR", "zR", opts, {desc = "Open all folds"})
-- map.set("n", "<leader>zc", "zc", opts, {desc = "Close fold"})
-- map.set("n", "<leader>zo", "zo", opts, {desc = "Open fold"})

-- window management
map.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
map.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
map.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
map.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- navegate beetween windows
-- map.set("n", "<C-l>", "<C-w>l", { desc = "Go right window" })
-- map.set("n", "<C-h>", "<C-w>h", { desc = "Go left window" })
-- map.set("n", "<C-j>", "<C-w>j", { desc = "Go down window" })
-- map.set("n", "<C-k>", "<C-w>k", { desc = "Go up window" })

-- increment/decrement numbers
map.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
map.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- buffers
-- vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", { noremap = false })

-- Resize with arrows
-- map.set("n", "<C-Up>", ":resize +2<CR>", opts)
-- map.set("n", "<C-Down>", ":resize -2<CR>", opts)
-- map.set("n", "<C-Left>", ":vertical resize +2<CR>", opts)
-- map.set("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- lazygit
map.set("n", "<leader>lg", "<cmd>LazyGit<cr>")

-- twilight
vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", { noremap = false })

-- Neogen (Docstring)
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- zen-mode
map.set("n", "zm", ":ZenMode<CR>", opts)

-- Obsidian
map.set(
    "n",
    "<leader>oc",
    "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>",
    { desc = "Obsidian Check Checkbox" }
)
map.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
map.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian App" })
map.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
map.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
map.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
map.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
map.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })

map.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- yank into clipboard even if on ssh
map.set("n", "<leader>y", "<Plug>OSCYankOperator")
map.set("v", "<leader>y", "<Plug>OSCYankVisual")

-- reload without exiting vim
map.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

map.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- source file
map.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- getting Alex off my back :)
map.set("n", "<leader>dg", "<cmd>DogeGenerate<cr>")

-- paste and don't replace clipboard over deleted text
map.set("x", "<leader>p", [["_dP]])
map.set({ "n", "v" }, "<leader>d", [["_d]])
