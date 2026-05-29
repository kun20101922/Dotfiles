-- oil 
vim.keymap.set('n', '<leader>e', '<cmd> Oil <cr>')

-- telescope
-- vim.keymap.set('n', '<leader>ff', '<cmd> Telescope find_files <cr>')
-- vim.keymap.set('n', '<leader>fb', '<cmd> Telescope buffers <cr>')
-- vim.keymap.set('n', '<leader>fc', '<cmd> Telescope colorscheme <cr>')
--
--- window
vim.keymap.set('n', 'sv', '<cmd> vsplit <cr>') -- vsplit 
vim.keymap.set('n', 'ss', '<cmd> split <cr>') -- split

-- buuffers line
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Lazy
vim.keymap.set("n", "<leader>l", "<cmd> Lazy <cr>")

-- move to window 
vim.keymap.set("n", "<C-l>", "<C-w>l>")
vim.keymap.set("n", "<C-h>", "<C-w>h>")
vim.keymap.set("n", "<C-k>", "<C-w>k>")
vim.keymap.set("n", "<C-j>", "<C-w>j>")

-- open terminal 
vim.keymap.set("n", "<leader>ft", "<cmd> FloatTerm <cr>")

-- quick files 
vim.keymap.set("n", "<leader>Q", "<cmd> QuickSwitch <cr>" )

-- fzf key
vim.keymap.set("n", "<leader>ff", "<cmd> FzfLua files<cr>")

-- vColor
vim.keymap.set("n", "<leader>vc", "<cmd> VCoolor <cr>")



