return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
      },
    })
  end,
}
