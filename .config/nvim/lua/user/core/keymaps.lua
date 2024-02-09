---------------------
-- General Keymaps
---------------------

--local map = vim.api.nvim_set_keymap
local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- set leader key to space
vim.g.mapleader = " "

-- use jk to exit insert mode
map("i", "jk", "<ESC>", default_opts)

-- clear search highlights
map("n", "<leader>nh", ":nohl<CR>", default_opts)

-- don't use arrow keys
map("", "<up>", "<nop>", { noremap = true })
map("", "<down>", "<nop>", { noremap = true })
map("", "<left>", "<nop>", { noremap = true })
map("", "<right>", "<nop>", { noremap = true })

map("i", "<C-h>", "<left>", default_opts)
map("i", "<C-j>", "<down>", default_opts)
map("i", "<C-k>", "<up>", default_opts)
map("i", "<C-l>", "<right>", default_opts)

-- fast saving with <leader> and w
map("n", "<leader>w", ":w<CR>", { desc = "Save file" }, default_opts)
-- map("i", "<leader>w", "<C-c>:w<CR>", default_opts)

-- format file
map("n", "<leader>fm", function()
  vim.lsp.buf.format({ timeout_ms = 5000 })
end, { desc = "Format file" })

-- set relativenumber
map("n", "<leader>r", ":set relativenumber!<CR>", { desc = "[R]elative number" }, default_opts)

-- quit
map("n", "q", "<cmd>q<cr>")

-- delete single character without copying into register
map("n", "x", '"_x')

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Icrement number" }, default_opts)
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }, default_opts)

-- window management
map("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [v]ertically" }, default_opts)
map("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [h]orizontally" }, default_opts)
map("n", "<leader>se", "<C-w>=", { desc = "Make [s]plit windows [e]qual width & height" }, default_opts)
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" }, default_opts)

map("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" }, default_opts)
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" }, default_opts)
map("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" }, default_opts)
map("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" }, default_opts)

-- move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h", default_opts)
map("n", "<C-j>", "<C-w>j", default_opts)
map("n", "<C-k>", "<C-w>k", default_opts)
map("n", "<C-l>", "<C-w>l", default_opts)

map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- find and replace worlds
-- map("n", "<C-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor"})
map("n", "<C-s>", [[:%s/<C-R><C-W>/<C-R>0/g]], { desc = "Replace word under cursor" })

----------------------
-- Plugin Keybinds
----------------------

-- bufferline
for number = 1, 9 do
  map("n", ("<leader>%s"):format(number), (":BufferLineGoToBuffer %s<cr>"):format(number), { silent = true })
end
map("n", "<Space>cb", "<cmd>bp|bd #<CR>", { desc = "Close current buffer" })
map("n", "<Space>cl", ":BufferLineCloseLeft<CR>", { desc = "Close left buffers" })
map("n", "<Space>cr", ":BufferLineCloseRight<CR>", { desc = "Close right buffers" })

-- neo-tree
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- lazygit
map("n", "<leader>lg", ":LazyGit<CR>", { desc = "[L]azy[G]it" })

-- vim-maximizer
map("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle [s]plit window [m]aximization" }, default_opts)

-- neogen
map("n", "<leader>ng", ":lua require('neogen').generate()<CR>", { desc = "Generate Doc", noremap = true })

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [F]iles" }, default_opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch by [G]rep" }, default_opts)
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" }, default_opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "[S]earch [B]uffers" }, default_opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp" }, default_opts)
map("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" }, default_opts)

map("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Search [G]it [F]iles" })
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", default_opts)
map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", default_opts)
map("n", "gr", "<cmd>Telescope lsp_references<cr>", default_opts)

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
map("n", "zo", function()
  require("ufo").openAllFolds()
end, { desc = "Open all folds" })
map("n", "zc", function()
  require("ufo").closeAllFolds()
end, { desc = "Close all folds" })

map("n", "zr", function()
  require("ufo").openFoldsExceptKinds()
end, { desc = "Close all folds" })
map("n", "zm", function()
  require("ufo").closeFoldsWith()
end, { desc = "Close all folds" }) -- closeAllFolds == closeFoldsWith(0)
map("n", "zK", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek fold" })

-- Pomo (Timer)
map("n", "<leader>ts", "<cmd>TimerStart 25m Work<cr>", { desc = "[T]imer [S]tart" })
map("n", "<leader>tb", "<cmd>TimerStop 5m Break<cr>", { desc = "[T]imer [B]reak" })
map("n", "<leader>th", "<cmd>TimerHide<cr>", { desc = "[T]imer [H]ide" })
map("n", "<leader>tw", "<cmd>TimerShow<cr>", { desc = "[T]imer Sho[w]" })
map("n", "<leader>tp", "<cmd>TimerPause<cr>", { desc = "[T]imer [P]ause" })
map("n", "<leader>tr", "<cmd>TimerResume<cr>", { desc = "[T]imer [R]esume" })

