return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      layout = {
        border = "single",
        spacing = 10,
        padding = { left = 5, right = 5 },
        margin = { top = 5, bottom = 5 },
      },
      delay = 1000,
      icons = {
        group = vim.g.icons_enabled ~= false and "" or "+",
        rules = false,
        separator = "-",
      },
    })
    wk.add({
      { "<leader>l", "LSP" },
      { "<leader>f", "Telescope" },
    })
  end,
}
