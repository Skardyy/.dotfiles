return {
  {
    "Skardyy/makurai-nvim", -- Make sure this matches your GitHub repo name exactly
    -- dir = "~/Desktop/makurai-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("makurai")
    end,
  },
}
