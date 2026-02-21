-- Auto-format on save
vim.g.autoformat = true
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.g.autoformat then
      require('conform').format({ bufnr = args.buf })
    end
  end,
})

-- cuz f conceal in markdown.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { 'markdown', 'help' },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end
})

-- enable treesitter highlight and indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- quit quickfix on q
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'q', function()
      vim.cmd('cclose')
      vim.cmd('wincmd p')
    end, { buffer = true, silent = true })
  end,
})

-- clear jump list at start
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("clearjumps")
  end,
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = "en_us"
  end,
})

-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
-- It seems that `checktime` does not work in command line. We need to check if we are in command
-- line before executing this command, see also https://vi.stackexchange.com/a/20397/15292 .
vim.api.nvim_create_augroup("auto_read", { clear = true })
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  group = "auto_read",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
  end,
})
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  pattern = "*",
  group = "auto_read",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Set terminal keymaps
function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- allow cd without args while also integrating it to oil
vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = ':',
  callback = function()
    local cmdline = vim.fn.getcmdline()

    if vim.v.event.abort then
      return
    end

    if cmdline == 'cd' then
      vim.schedule(function()
        vim.cmd('cd ~')
        vim.cmd('pwd')
        local cwd = vim.fn.getcwd()
        require("oil").open(cwd)
        require("aerial").close() -- make sure aerial isn't visible (it doesn't contain symbols anyways)
      end)
    elseif cmdline:match('^cd%s') then
      vim.schedule(function()
        local cwd = vim.fn.getcwd()
        require("oil").open(cwd)
        require("aerial").close() -- make sure aerial isn't visible (it doesn't contain symbols anyways)
      end)
    end
  end
})

-- sadly needed, alot of changes to files lsp isn't catching up.
vim.api.nvim_create_user_command("Reset", function()
  local current = vim.api.nvim_buf_get_name(0)
  vim.cmd("bufdo bd")
  if current ~= "" then
    vim.cmd("edit " .. current)
    vim.cmd("LspRestart")
  end
end, {})
