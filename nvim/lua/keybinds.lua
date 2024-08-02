local opts = { noremap = true, silent = true }

---------------------------------
-- Normal mode mappings
---------------------------------

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>h', ':noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>/', 'gcc', { noremap = false, silent = true } )
vim.api.nvim_set_keymap('n', '<leader>n', ':cn<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>N', ':cp<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-j>', '<C-d>', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-u>', opts)

---------------------------------
-- Visual mode mapping
---------------------------------

vim.api.nvim_set_keymap('v', '<leader>/', 'gc', { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', opts)
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', opts)
