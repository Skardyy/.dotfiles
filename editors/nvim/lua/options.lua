vim.g.mapleader = " "
vim.g.localleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = '· ', leadmultispace = '· ', trail = '⋅' }
vim.deprecate = function() end -- i don't want to hear about it..
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.laststatus = 3
vim.o.wrap = false;
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.guicursor:append("a:blinkon0")
vim.opt.guicursor:append("a:Cursor/lCursor")

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
  bash = {
    lsp = "bash-language-server",
  },
  fish = {
    lsp = "fish-lsp",
  }
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

vim.g.neovide_padding_top = 12
vim.g.neovide_padding_right = 12
vim.g.neovide_padding_left = 12
vim.g.neovide_floating_shadow = false
