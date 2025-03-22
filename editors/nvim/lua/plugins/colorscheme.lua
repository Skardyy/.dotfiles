return {
  {
    "Skardyy/makurai-nvim",
    -- dir = "~/Desktop/makurai-nvim",
    config = function()
      require "makurai".setup({
        transparent = true
      })
      -- vim.cmd.colorscheme("makurai")
    end,
  },
}
