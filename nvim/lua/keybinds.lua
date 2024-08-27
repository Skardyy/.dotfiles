local opts = { noremap = true, silent = true }
function ToggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is " .. (vim.g.autoformat and "ON" or "OFF"))
end

function ToggleQuickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
  else
    vim.cmd "copen"
  end
end

---------------------------------
-- Normal mode mappings
---------------------------------

vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save" })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })
vim.api.nvim_set_keymap("n", "<leader>h", ":noh<CR>", { noremap = true, silent = true, desc = "No highlight" })
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { noremap = false, silent = true, desc = "Comment" })
vim.api.nvim_set_keymap("n", "<leader>c", ":bd<CR>", { noremap = false, silent = true, desc = "Close buffer" })
vim.api.nvim_set_keymap("n", "<leader>C", ":bd!<CR>", { noremap = false, silent = true, desc = "CLOSE buffer" })
vim.api.nvim_set_keymap("n", "<leader>n", ":enew<CR>", { noremap = false, silent = true, desc = "New buffer" })
vim.api.nvim_set_keymap("n", "<leader>t", ":term<CR>", { noremap = false, silent = true, desc = "Open terminal" })
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>lua ToggleQuickfix()<CR>',
  { noremap = true, silent = true, desc = "Toggle quickfix" })
vim.keymap.set("n", "<leader>lq", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end, { noremap = false, silent = true, desc = "Quick lsp fix" })
vim.api.nvim_set_keymap("n", "<C-n>", ":cn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":cp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>F",
  ":lua ToggleAutoformat()<CR>",
  { noremap = true, silent = true, desc = "Toggle autoformat" }
)

---------------------------------
-- Visual mode mapping
---------------------------------

vim.api.nvim_set_keymap("v", "<leader>/", "gc", { noremap = false, silent = true, desc = "Comment" })
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", opts)
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", opts)
