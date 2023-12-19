-- Keymaps are automatically loaded on the VeryLazy event

local map = vim.keymap.set

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- move lines
map("n", "∆", "<cmd>m .+1<cr>==", { desc = "move down"})
map("n", "˚", "<cmd>m .-2<cr>==", { desc = "move up"})
map("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "move down"})
map("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "move up"})
map("v", "∆", ":m '>+1<cr>gv=gv", { desc = "move down"})
map("v", "˚", ":m '<-2<cr>gv=gv", { desc = "move up"})

-- emacs move
map("i", "<C-A>", "<Home>", { desc = "move to beginning of line" })
map("i", "<C-E>", "<End>", { desc = "move to end of line" })
map("i", "<C-B>", "<Left>", { desc = "move one character left" })
map("i", "<C-F>", "<Right>", { desc = "move one character right" })

-- buffer
map("n", "<leader><Tab>", "<C-^>", { desc = "switch to previous buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "previous buffer" })
map("n", "<leader>bd", ":bd<CR>", { desc = "delete buffer" })

-- bufferline
map("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", { desc = "go to buffer 1" })
map("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", { desc = "go to buffer 2" })
map("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", { desc = "go to buffer 3" })
map("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", { desc = "go to buffer 4" })
map("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", { desc = "go to buffer 5" })
map("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>", { desc = "go to buffer 6" })
map("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>", { desc = "go to buffer 7" })
map("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>", { desc = "go to buffer 8" })
map("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>", { desc = "go to buffer 9" })

-- window
map("n", "<leader>wh", "<C-w>h", { desc = "move to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "move to bottom window" })
map("n", "<leader>wk", "<C-w>k", { desc = "move to top window" })
map("n", "<leader>wl", "<C-w>l", { desc = "move to right window" })
map("n", "<leader>w=", "<C-w>=", { desc = "equalize window sizes" })
map("n", "<leader>wq", "<C-w>q", { desc = "close window" })
map("n", "<leader>w-", ":split<CR><C-w>j<ESC>", { desc = "split horizontal" })
map("n", "<leader>w/", ":vsplit<CR><C-w>l<ESC>", { desc = "split vertical" })
map("n", "<C-x>1", "<C-w>o", { desc = "close all other windows" })
