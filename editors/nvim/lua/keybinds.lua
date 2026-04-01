local opts = { silent = true }
function ToggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is " .. (vim.g.autoformat and "ON" or "OFF"))
end

function ToggleQuickfix()
  -- check if quickfix is already open and close it
  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "quickfix" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end

  -- no quickfix found, check for any non floating split below main window
  local main_win = get_main_win()
  if not main_win then return end

  vim.api.nvim_set_current_win(main_win)
  local below_win = vim.fn.win_getid(vim.fn.winnr("j"))

  if below_win and below_win ~= main_win then
    local buf = vim.api.nvim_win_get_buf(below_win)
    local cfg = vim.api.nvim_win_get_config(below_win)
    if cfg.relative == "" and vim.bo[buf].buftype ~= "" then
      vim.api.nvim_win_close(below_win, false)
      return
    end
  end

  -- nothing below, open quickfix
  vim.cmd "copen"
  vim.api.nvim_set_current_win(main_win)
end

function _G.get_main_win()
  local normal_types = { [""] = true, ["acwrite"] = true }

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local cfg = vim.api.nvim_win_get_config(win)
    if normal_types[vim.bo[buf].buftype] and cfg.relative == ""
    then
      return win
    end
  end
end

---------------------------------
-- Normal mode mappings
---------------------------------

vim.keymap.set("n", "zo", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "zO", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>1", "gg=G``",
  { silent = true, desc = "Format Buffer" })
vim.keymap.set("n", "<leader>h", ":noh<CR>", { silent = true, desc = "No highlight" })
vim.keymap.set('n', '<leader>q', ':lua ToggleQuickfix()<CR>',
  { silent = true, desc = "Toggle quickfix" })
vim.keymap.set("n", "<C-n>", ":cn<CR>", opts)
vim.keymap.set("n", "<C-p>", ":cp<CR>", opts)
vim.keymap.set(
  "n",
  "<leader>F",
  ":lua ToggleAutoformat()<CR>",
  { silent = true, desc = "Toggle autoformat" }
)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
-- i don't like those
vim.keymap.set('n', 'H', '<Nop>')
vim.keymap.set('n', 'L', '<Nop>')

-- paste
vim.keymap.set('c', '<C-S-v>', '<C-r>+', { noremap = true })
vim.keymap.set('i', '<C-S-v>', '<C-r>+', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-S-v>', '"+p', { noremap = true })

---------------------------------
-- Visual mode mapping
---------------------------------

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
