return {
  "Skardyy/makurai-nvim",
  -- dir = "~/Desktop/makurai-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require "makurai".setup({
      -- transparent = true
    })
    -- vim.cmd.colorscheme("makurai")
  end,
}
