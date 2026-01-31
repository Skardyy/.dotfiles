vim.g.mapleader = " "
vim.g.localleader = " "

vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.conceallevel = 0    -- so that `` is visible in markdown files
vim.opt.hlsearch = true     -- highlight all matches on previous search pattern
vim.opt.ignorecase = true   -- ignore case in search patterns
vim.opt.mouse = "a"         -- allow the mouse to be used in neovim
vim.opt.smartcase = true    -- smart case
vim.opt.smartindent = true  -- make indenting smarter again
vim.opt.splitbelow = true   -- force all horizontal splits to go below current window
vim.opt.splitright = true   -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false    -- creates a swapfile
vim.opt.tgc = true          -- set term gui colors (most terminals support this)
vim.opt.undofile = true     -- enable persistent undo
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.tabstop = 2         -- insert 2 spaces for a tab
vim.opt.expandtab = true    -- convert tabs to spaces
vim.opt.shiftwidth = 2      -- the number of spaces inserted for each indentation
vim.opt.cursorline = true   -- highlight the current line
vim.opt.number = true       -- set numbered lines
vim.opt.wrap = false        -- display lines as one long line
vim.opt.list = true
vim.opt.listchars = { tab = '· ', leadmultispace = '· ', trail = '⋅' }
vim.deprecate = function() end -- i don't want to hear about it..
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.guicursor:append("a:blinkon0")

-- LSP like in mason
-- Formatter like in conform
-- Linter like in nvim-lint
vim.g.lang_maps = {
  python = {
    lsp = { "ty", "basedpyright" },
    linter = "ruff",
    formatter = "ruff_format",
  },
  typescript = {
    lsp = "typescript-language-server",
    linter = "eslint_d",
    formatter = "prettierd",
  },
  typescriptreact = {
    lsp = "typescript-language-server",
    linter = "eslint_d",
    formatter = "prettierd",
  },
  javascript = {
    lsp = "typescript-language-server",
    linter = "eslint_d",
    formatter = "prettierd",
  },
  javascriptreact = {
    lsp = "typescript-language-server",
    linter = "eslint_d",
    formatter = "prettierd",
  },
  lua = {
    lsp = "lua-language-server",
  },
  rust = {
    lsp = "rust-analyzer",
  },
  go = {
    lsp = "gopls",
  },
  markdown = {
    formatter = "prettierd",
  },
  cpp = {
    lsp = "clangd",
  },
  typst = {
    lsp = "tinymist",
  },
}

-- Make command work on windows, i hate windows..
if vim.fn.has('win32') == 1 then
  vim.o.shell = 'pwsh'
  vim.o.shellcmdflag = '-c'
  vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.fillchars:append({
  stl = " ",
})

vim.o.guifont = "CommitMonoMn Nerd Font:h16"
vim.g.neovide_refresh_rate = 170
