return {
  {
    "Skardyy/makurai-nvim",
    -- dir = "~/Desktop/makurai-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("makurai")
    end,
  },
}
