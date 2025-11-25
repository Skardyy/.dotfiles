return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jay-babu/mason-null-ls.nvim"
  },
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup()

    require('mason-null-ls').setup({
      handlers = {},
    })
  end
}
