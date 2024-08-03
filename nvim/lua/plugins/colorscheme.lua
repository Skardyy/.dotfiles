return {
  {
    "Skardyy/makurai-nvim", -- Make sure this matches your GitHub repo name exactly
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("makurai")
    end,
  },
}
