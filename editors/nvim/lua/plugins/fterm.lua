return {
  "numToStr/FTerm.nvim",
  config = function()
    require 'FTerm'.setup({
      dimensions = {
        height = 0.9,
        width = 0.9,
        x = 0.5,
        y = 0.2,
      },
    })
  end
}
