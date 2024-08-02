return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- These will be automatically configured if they're installed
        -- You don't need to specify them manually, but you can keep them if you want
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
