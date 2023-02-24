-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


vim.keymap.set("n", "<leader>,", "<Cmd>nohl<CR>")
vim.keymap.set("n", "<leader>ls", "'0<CR>" )
vim.keymap.set("n", "<Leader>n", ":set relativenumber!<CR>", { desc = 'Set relativenumber' })

-- buffer and aplist navigation
vim.keymap.set("n", "<leader><leader>", "<C-^>", {desc = 'Buffer files'})
vim.keymap.set("n", "<C-h>", "<C-w>h<CR>")
vim.keymap.set("n", "<C-j>", "<C-w>j<CR>")
vim.keymap.set("n", "<C-k>", "<C-w>k<CR>")
vim.keymap.set("n", "<C-l>", "<C-w>l<CR>")

vim.keymap.set("n", "<leader>Q", "<C-w>c<CR>", { desc = 'Close last window' })
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", {desc = 'Save edition'})
vim.keymap.set("n", "<leader>z", "<Cmd>bp<CR>", {desc = 'Previous tab'})
vim.keymap.set("n", "<leader>x", "<Cmd>bn<CR>", {desc = 'Next tab'})
vim.keymap.set("n", "<leader>qa", "<Cmd>bufdo bw<CR>", {desc = 'Close current tab'})
vim.keymap.set("n", "<leader>q", "<Cmd>bw<CR>", {desc = 'Show errors'})
vim.keymap.set('n', 'q', ':quit <CR>', {desc = 'Quit'})

-- indent and keep selection
vim.keymap.set("", ">", ">gv", { desc = 'Indent line right' })
vim.keymap.set("", "<", "<gv", { desc = 'Indent line left' })

-- move lines up and down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move line UP' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move line DOWN' })

-- disable arrows
-- vim.keymap.set("n", "<up>", "<nop>")
-- vim.keymap.set("n", "<down>", "<nop>")
-- vim.keymap.set("n", "<left>", "<nop>")
-- vim.keymap.set("n", "<right>", "<nop>")
-- vim.keymap.set("i", "<up>", "<nop>")
-- vim.keymap.set("i", "<down>", "<nop>")
-- vim.keymap.set("i", "<left>", "<nop>")
-- vim.keymap.set("i", "<right>", "<nop>")

-- autocompete line and filename
vim.keymap.set("i", '<C-l>', '<C-x><C-l>')
vim.keymap.set("i", '<C-f>', '<C-x><C-f>')

-- stop c, s and d from yanking
vim.keymap.set("n", "c", [["_c]])
vim.keymap.set("x", "c", [["_c]])
vim.keymap.set("n", "s", [["_s]])
vim.keymap.set("x", "s", [["_s]])
vim.keymap.set("n", "d", [["_d]])
vim.keymap.set("x", "d", [["_d]])

-- stop p from overwtitting the register (by re-yanking it)
vim.keymap.set("x", "p", "pgvy")

-- keep centered when n/N/J
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("v", "$", "$h", {desc = 'Select the end of the line without linebreak'})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymap' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("n", "<Leader>t", "<Cmd>NvimTreeToggle<CR>", {desc = 'Tree navigation'})

vim.keymap.set("n", "<leader>c", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", {desc = '[C]omment'})
vim.keymap.set("x", "<leader>c", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")


--Fugitive (Commmands git)
-- vim.keymap.set("n", "<leader>gh", "<Cmd>!git<CR>", {desc = '[g]it [h]elp'})
-- vim.keymap.set("n", "<leader>gs", "<Cmd>:Git status<CR>", {desc = '[g]it [s]tatus'})
-- vim.keymap.set("n", "<leader>ga", "<Cmd>:Git add<CR>", {desc = '[g]it [a]dd'})
-- vim.keymap.set("n", "<leader>gc", "<Cmd>:Git commit<CR>", {desc = '[g]it [c]ommit'})
-- vim.keymap.set("n", "<leader>gpu", "<Cmd>:Git push<CR>", {desc = '[g]it [pu]sh'})
-- vim.keymap.set("n", "<leader>gch", "<Cmd>:Git read<CR>", {desc = '[g]it [c]heckout (Revert current file to last checked in version)'})
-- vim.keymap.set("n", "<leader>gre", "<Cmd>:Git rebase -i<CR>", {desc = '[g]it [r]ebase'})
-- vim.keymap.set("n", "<leader>gd", "<Cmd>:Git diff<CR>", {desc = '[g]it [d]iff'})
-- vim.keymap.set("n", "<leader>gb", "<Cmd>:Git blame<CR>", {desc = '[g]it [b]lame'})
-- vim.keymap.set("n", "<leader>gl", "<Cmd>:Git log<CR>", {desc = '[g]it [l]og'})
-- vim.keymap.set("n", "<leader>gpa", "<Cmd>:Git --paginate<CR>", {desc = '[g]it [pa]ginate'})








-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})