local opts = { noremap = true, silent = true }
function ToggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is " .. (vim.g.autoformat and "ON" or "OFF"))
end

function FindDirectory()
  local current_dir = vim.fn.expand('%:p:h'):gsub("^oil://", "")
  if vim.fn.has('win32') == 1 then
    current_dir = current_dir:gsub("^(%a)([/\\])", "%1:%2")
    current_dir = current_dir:gsub("/", "\\")
    current_dir = current_dir:gsub("\\C\\", "C:\\")
  end
  vim.ui.input({
    prompt = "Directory: ",
    default = current_dir,
    completion = "dir",
  }, function(input)
    if input then
      vim.cmd('edit ' .. input)
      vim.cmd('cd ' .. input)
    end
  end)
end

function ExecuteCommand()
  vim.ui.input({
    prompt = "Command:",
    default = "",
    completion = 'command'
  }, function(input)
    if input then
      vim.cmd('terminal ' .. input)
    end
  end)
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

vim.api.nvim_set_keymap("n", "<leader>1", ":lua vim.lsp.buf.format()<CR>",
  { noremap = true, silent = true, desc = "Format Buffer" })
vim.api.nvim_set_keymap("n", "<leader>w", ":w!<CR>", { noremap = true, silent = true, desc = "Save" })
vim.api.nvim_set_keymap("n", "<leader>h", ":noh<CR>", { noremap = true, silent = true, desc = "No highlight" })
vim.api.nvim_set_keymap("n", "<leader>c", ":bd<CR>", { noremap = false, silent = true, desc = "Close buffer" })
vim.api.nvim_set_keymap("n", "<leader>C", ":bd!<CR>", { noremap = false, silent = true, desc = "CLOSE buffer" })
vim.api.nvim_set_keymap("n", "<leader>n", ":enew<CR>", { noremap = false, silent = true, desc = "New buffer" })
vim.api.nvim_set_keymap("n", "<leader>t", ":lua ExecuteCommand()<CR>",
  { noremap = false, silent = true, desc = "Run Command" })
vim.api.nvim_set_keymap('n', '<leader>fd', ':lua FindDirectory()<CR>',
  { noremap = false, silent = true, desc = "Open Dir" })
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

vim.api.nvim_set_keymap("v", "<Tab>", ">gv", opts)
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", opts)
