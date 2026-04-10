-- auto format on save
vim.g.autoformat = true
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.g.autoformat then
      require('conform').format({ bufnr = args.buf })
    end
  end,
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
  pattern = { 'qf', 'help' },
  callback = function()
    vim.keymap.set('n', 'q', function()
      vim.cmd('close')
      -- vim.cmd('wincmd p')
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
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = "en_us"
  end,
})

-- message when file changed from outside
vim.api.nvim_create_augroup("auto_read", { clear = true })
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  group = "auto_read",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
  end,
})

-- check for changes on some events
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  pattern = "*",
  group = "auto_read",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- set terminal keymaps
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
