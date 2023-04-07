-- [[ Setting keymaps ]]

local mappings = {

  -- Increment/decrement
  { "n", "+",            "<C-a>" },
  { "n", "-",            "<C-x>" },

  -- Select all
  { "n", "<C-a>",        "gg<S-v>G" },

  -- New tab
  { "n", "te",           ":tabedit<CR>" },

  -- Split window
  { 'n', 'ss',           ':split<Return><C-w>w' },
  { 'n', 'sv',           ':vsplit<Return><C-w>w' },

  -- Move window
  { 'n', '<Space>',      '<C-w>w' },
  { '',  'sh',           '<C-w>h' },
  { '',  'sk',           '<C-w>k' },
  { '',  'sj',           '<C-w>j' },
  { '',  'sl',           '<C-w>l' },

  -- Resize window
  { 'n', '<C-w><left>',  '<C-w><' },
  { 'n', '<C-w><right>', '<C-w>>' },
  { 'n', '<C-w><up>',    '<C-w>+' },
  { 'n', '<C-w><down>',  '<C-w>-' },

  -- Set relativenumber
  { "n", "<Leader>r",    ":set relativenumber!<CR>" },

  -- Save
  { "n", "<leader>w",    ":w<CR>" },

  -- Quit
  { "n", "q",            "<cmd>q<cr>" },

  -- buffer and split management
  { "n", "<leader>Q",    "<C-w>c<CR>" },
  { "n", "<leader>qa",   "<Cmd>bufdo bw<CR>" },
  -- { "n", "<leader>q", "<Cmd>bw<CR>" },

  -- indent and keep selection
  { "",  ">",            ">gv",                         {} },
  { "",  "<",            "<gv",                         {} },

  -- move lines up and down
  { "n", "<C-j>",        ":m .+1<CR>==" },
  { "n", "<C-k>",        ":m .-2<CR>==" },
  { "v", "J",            ":m '>+1<CR>gv=gv" },
  { "v", "K",            ":m '<-2<CR>gv=gv" },

  -- stop c, s and d from yanking
  { "n", "c",            [["_c]] },
  { "x", "c",            [["_c]] },
  { "n", "s",            [["_s]] },
  { "x", "s",            [["_s]] },
  { "n", "d",            [["_d]] },
  { "x", "d",            [["_d]] },

  -- stop p from overwtitting the register (by re-yanking it)
  { "x", "p",            "pgvy" },

  -- keep centered when n/N/J
  { "n", "n",            "nzz" },
  { "n", "N",            "Nzz" },
  { "n", "J",            "mzJ`z" },

  -- select the end of the line without linebreak
  { "v", "$",            "$h" },

  -- neo-tree toggle options
  { "n", "<leader>t",    "<Cmd>:NeoTreeFocusToggle<CR>" },
  -- ZenMode
  { "n", "zz",           "<Cmd>:ZenMode<CR>",           { silent = true } },
}
for _, val in pairs(mappings) do
  vim.keymap.set(unpack(val))
end
