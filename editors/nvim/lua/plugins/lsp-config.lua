return {
  {
    "williamboman/mason.nvim",
    commit = "fc98833b6da",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    commit = "1a31f824b9cd5b",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },
  { "folke/neodev.nvim", opts = {} },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("neodev").setup({})
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })

      local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = ""
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●", -- Bullet point (or change it)
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          header = "",
        },
      })

      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded" })
      end, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Goto references" })
      vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Hover diagnostics" })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        automatic_setup = true,
      })
    end,
  },
}
