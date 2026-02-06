local opts = { silent = true }
function ToggleAutoformat()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is " .. (vim.g.autoformat and "ON" or "OFF"))
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
    local win = vim.api.nvim_get_current_win()
    vim.cmd "copen"
    vim.api.nvim_set_current_win(win)
  end
end

function TelescopeGitDiff()
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_commits({
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        vim.cmd('DiffviewOpen HEAD..' .. selection.value)
      end)

      return true
    end,
  })
end

---------------------------------
-- Normal mode mappings
---------------------------------

vim.keymap.set("n", "zo", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "zO", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>1", "gg=G``",
  { silent = true, desc = "Format Buffer" })
vim.keymap.set("n", "<leader>h", ":noh<CR>", { silent = true, desc = "No highlight" })
vim.keymap.set("n", "<leader>c", ":lua ExecuteCommand()<CR>",
  { silent = true, desc = "Run Command" })
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

---------------------------------
-- Visual mode mapping
---------------------------------

vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)
