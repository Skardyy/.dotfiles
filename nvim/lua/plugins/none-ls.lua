return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup {}
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
  end,
}
