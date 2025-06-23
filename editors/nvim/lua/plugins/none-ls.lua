return {
  "nvimtools/none-ls.nvim",
  lazy = false,
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup {}
  end,
}
