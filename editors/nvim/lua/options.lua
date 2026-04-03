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
vim.deprecate = function() end
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.laststatus = 3
vim.o.wrap = false;
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cmdheight = 0
vim.opt.guicursor:append("a:blinkon0")
vim.opt.guicursor:append("a:Cursor/lCursor")
vim.opt.fillchars = vim.opt.fillchars + "eob: "

require("vim._core.ui2").enable {
  msg = {
    targets = "msg",
    msg = {
      timeout = 3000,
    },
  },
}

---@class LspConfig
---@field name string the name of the LSP (e.g., "rust-analyzer")
---@field global? boolean if true, don't check Mason; use system binary
---@field config? table configuration object for lspconfig (flags, settings, etc.)

---@class LangConfig
---@field lsp? LspConfig
---@field linter? string
---@field formatter? string

---@param conf string
---@return LspConfig
local function lsp(conf)
  return { name = conf, global = false, config = {} }
end

---@type table<string, LangConfig>
vim.g.lang_maps = {
  python = {
    lsp = lsp("basedpyright"),
    linter = "ruff",
    formatter = "ruff",
  },
  typescript = {
    lsp = lsp("typescript-language-server"),
    linter = "eslint_d",
    formatter = "prettierd",
  },
  typescriptreact = {
    lsp = lsp("typescript-language-server"),
    linter = "eslint_d",
    formatter = "prettierd",
  },
  javascript = {
    lsp = lsp("typescript-language-server"),
    linter = "eslint_d",
    formatter = "prettierd",
  },
  javascriptreact = {
    lsp = lsp("typescript-language-server"),
    linter = "eslint_d",
    formatter = "prettierd",
  },
  lua = {
    lsp = lsp("lua-language-server"),
  },
  rust = {
    lsp = {
      name = "rust_analyzer",
      global = true,
      config = {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--target-dir", "target/analyzer" },
            },
            checkOnSave = true,
          }
        }
      }
    },
  },
  go = {
    lsp = lsp("gopls"),
  },
  markdown = {
    formatter = "prettierd",
  },
  cpp = {
    lsp = lsp("clangd"),
  },
  typst = {
    lsp = lsp("tinymist"),
  },
  bash = {
    lsp = lsp("bash-language-server"),
  },
  fish = {
    lsp = lsp("fish-lsp"),
  }
}
