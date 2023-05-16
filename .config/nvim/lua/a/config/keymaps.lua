-- [[ Setting keymaps ]]

-- local mappings = {

--   -- Increment/decrement
--   { "n", "+",            "<C-a>" },
--   { "n", "-",            "<C-x>" },

--   -- Select all
--   { "n", "<C-a>",        "gg<S-v>G" },

--   -- New tab
--   { "n", "te",           ":tabedit<CR>" },

--   -- Split window
--   { 'n', 'ss',           ':split<Return><C-w>w' },
--   { 'n', 'sv',           ':vsplit<Return><C-w>w' },

--   -- Move window
--   { 'n', '<Space>',      '<C-w>w' },
--   { '',  'sh',           '<C-w>h' },
--   { '',  'sk',           '<C-w>k' },
--   { '',  'sj',           '<C-w>j' },
--   { '',  'sl',           '<C-w>l' },

--   -- Resize window
--   { 'n', '<C-w><left>',  '<C-w><' },
--   { 'n', '<C-w><right>', '<C-w>>' },
--   { 'n', '<C-w><up>',    '<C-w>+' },
--   { 'n', '<C-w><down>',  '<C-w>-' },

--   -- Set relativenumber
--   { "n", "<Leader>r",    ":set relativenumber!<CR>" },

--   -- Save
--   { "n", "<leader>w",    ":w<CR>" },

--   -- Quit
--   { "n", "q",            "<cmd>q<cr>" },

--   -- buffer and split management
--   { "n", "<leader>Q",    "<C-w>c<CR>" },
--   { "n", "<leader>qa",   "<Cmd>bufdo bw<CR>" },
--   -- { "n", "<leader>q", "<Cmd>bw<CR>" },

--   -- indent and keep selection
--   { "",  ">",            ">gv",                         {} },
--   { "",  "<",            "<gv",                         {} },

--   -- move lines up and down
--   { "n", "<C-j>",        ":m .+1<CR>==" },
--   { "n", "<C-k>",        ":m .-2<CR>==" },
--   { "v", "J",            ":m '>+1<CR>gv=gv" },
--   { "v", "K",            ":m '<-2<CR>gv=gv" },

--   -- stop c, s and d from yanking
--   { "n", "c",            [["_c]] },
--   { "x", "c",            [["_c]] },
--   { "n", "s",            [["_s]] },
--   { "x", "s",            [["_s]] },
--   { "n", "d",            [["_d]] },
--   { "x", "d",            [["_d]] },

--   -- stop p from overwtitting the register (by re-yanking it)
--   { "x", "p",            "pgvy" },

--   -- keep centered when n/N/J
--   { "n", "n",            "nzz" },
--   { "n", "N",            "Nzz" },
--   { "n", "J",            "mzJ`z" },

--   -- select the end of the line without linebreak
--   { "v", "$",            "$h" },

--   -- neo-tree toggle options
--   { "n", "<leader>t",    "<Cmd>:NeoTreeFocusToggle<CR>" },
--   -- ZenMode
--   { "n", "zz",           "<Cmd>:ZenMode<CR>",           { silent = true } },
-- }
-- for _, val in pairs(mappings) do
--   vim.keymap.set(unpack(val))
-- end




---------------------
-- General Keymaps
---------------------

--local map = vim.api.nvim_set_keymap
local map = vim.keymap.set
local default_opts = {noremap = true, silent = true}


-- set leader key to space
vim.g.mapleader = " "

-- use jk to exit insert mode
map("i", "jk", "<ESC>", default_opts)

-- clear search highlights
map("n", "<leader>nh", ":nohl<CR>", default_opts)

-- don't use arrow keys
map('', '<up>', '<nop>', {noremap = true})
map('', '<down>', '<nop>', {noremap = true})
map('', '<left>', '<nop>', {noremap = true})
map('', '<right>', '<nop>', {noremap = true})

map('i', '<C-h>', '<left>', default_opts)
map('i', '<C-j>', '<down>', default_opts)
map('i', '<C-k>', '<up>', default_opts)
map('i', '<C-l>', '<right>', default_opts)

-- fast saving with <leader> and w
map('n', '<leader>w', ':w<CR>', default_opts)
map('i', '<leader>w', '<C-c>:w<CR>', default_opts)

-- Set relativenumber
map("n", "<Leader>r", ":set relativenumber!<CR>", default_opts)

-- delete single character without copying into register
map("n", "x", '"_x')

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", default_opts) -- increment
map("n", "<leader>-", "<C-x>", default_opts) -- decrement

-- window management
map("n", "<leader>sv", "<C-w>v", default_opts) -- split window vertically
map("n", "<leader>sh", "<C-w>s", default_opts) -- split window horizontally
map("n", "<leader>se", "<C-w>=", default_opts) -- make split windows equal width & height
map("n", "<leader>sx", ":close<CR>", default_opts) -- close current split window

map("n", "<leader>to", ":tabnew<CR>", default_opts) -- open new tab
map("n", "<leader>tx", ":tabclose<CR>", default_opts) -- close current tab
map("n", "<leader>tn", ":tabn<CR>", default_opts) --  go to next tab
map("n", "<leader>tp", ":tabp<CR>", default_opts) --  go to previous tab

-- move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', default_opts)
map('n', '<C-j>', '<C-w>j', default_opts)
map('n', '<C-k>', '<C-w>k', default_opts)
map('n', '<C-l>', '<C-w>l', default_opts)


----------------------
-- Plugin Keybinds
----------------------

--nvim-lazygit
map('n', '<C-g>', ':LazyGit<CR>', default_opts)

-- vim-maximizer
map("n", "<leader>sm", ":MaximizerToggle<CR>", default_opts) -- toggle split window maximization

-- nvim-tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", default_opts) -- toggle file explorer

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [F]iles" }, default_opts)
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch by [G]rep" }, default_opts)
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" }, default_opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "[S]earch [B]uffers" }, default_opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp" }, default_opts)
map("n", '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" }, default_opts)

-- telescope git commands (not on youtube nvim video)
map("n", "<leader>gf", "<cmd>Telescope git_files<cr>", default_opts, { desc = "Search [G]it [F]iles" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", default_opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
map("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", default_opts) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", default_opts) -- list git branches (use <cr> to checkout) ["gb" for git branch]
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", default_opts) -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
map("n", "<leader>rs", ":LspRestart<CR>", default_opts) -- mapping to restart lsp if necessary

-- cokeline
for i = 1,9 do
  map('n', ('<F%s>'):format(i),      ('<Plug>(cokeline-focus-%s)'):format(i),  { silent = true })
  map('n', ('<Leader>%s'):format(i), ('<Plug>(cokeline-focus-%s)'):format(i), { silent = true })
end

-- Neogen
map("n", "<leader>ng", ":lua require('neogen').generate()<CR>", { noremap = true })