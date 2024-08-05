local opts = { noremap = true, silent = true }

---------------------------------
-- Normal mode mappings
---------------------------------

vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save" })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })
vim.api.nvim_set_keymap("n", "<leader>h", ":noh<CR>", { noremap = true, silent = true, desc = "No highlight" })
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { noremap = false, silent = true, desc = "Comment" })
vim.api.nvim_set_keymap("n", "<leader>c", ":bd<CR>", { noremap = false, silent = true, desc = "Close buffer" })
vim.api.nvim_set_keymap("n", "<leader>o", ":enew<CR>", { noremap = false, silent = true, desc = "New buffer" })
vim.api.nvim_set_keymap("n", "<C-n>", ":cn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-N>", ":cp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-d>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-u>", opts)
vim.api.nvim_set_keymap("n", "H", ":bprevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", ":bnext<CR>", { noremap = true, silent = true })

---------------------------------
-- Visual mode mapping
---------------------------------

vim.api.nvim_set_keymap("v", "<leader>/", "gc", { noremap = false, silent = true, desc = "Comment" })
vim.api.nvim_set_keymap("v", "<Tab>", ">", opts)
vim.api.nvim_set_keymap("v", "<S-Tab>", "<", opts)
