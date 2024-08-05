return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        show_buffer_close_icons = false,
        indicator = {
          icon = "",
          style = "none",
        },
        diagnostics = "nvim_lsp",
        seperator_style = "thin",
        show_tab_indicators = false,
      },
    })
  end,
}
