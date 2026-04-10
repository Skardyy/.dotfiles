return {
  "Skardyy/makurai-nvim",
  -- dir = "~/Desktop/makurai-nvim", -- for  testing
  lazy = false,
  priority = 1000,
  config = function()
    if not vim.g.neovide then
      require "makurai".setup({
        transparent = true
      })
    end
    vim.cmd.colorscheme("makurai_autumn")
  end,
}
