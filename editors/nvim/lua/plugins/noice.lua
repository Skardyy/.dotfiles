return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline"
      },
      presets = {
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    })
  end,
}
