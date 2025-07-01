return {
  -- "Skardyy/makurai-nvim",
  dir = "~/Desktop/makurai-nvim",
  lazy = false,
  config = function()
    require "makurai".setup({
      bordered = true
    })
    vim.cmd.colorscheme("makurai_dark")
  end,
}
