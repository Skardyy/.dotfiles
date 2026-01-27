return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {}
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local registry = require("mason-registry")

      for _, tools in pairs(vim.g.lang_maps) do
        if tools.lsp and registry.is_installed(tools.lsp) then
          local name = tools.lsp
          local pkg = registry.get_package(name)
          if pkg.spec.neovim then
            name = pkg.spec.neovim.lspconfig
            vim.lsp.config(name, { capabilities = capabilities })
            vim.lsp.enable(name)
          end
        end
      end

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
          prefix = "●",
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
  }
}
