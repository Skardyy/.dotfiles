return {
  "bassamsdata/namu.nvim",
  config = function()
    require("namu").setup({
      namu_symbols = {
        options = {
          movement = {
            next = "<Tab>"
          },
          multiselect = {
            enabled = false
          }
        }
      },
      colorscheme = {
        enable = true,
        options = {
          persist = true,
          write_shada = false,
        },
      },
    })
  end,
}
