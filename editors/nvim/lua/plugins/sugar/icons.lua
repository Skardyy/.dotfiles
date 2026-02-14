return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  config = function()
    require("nvim-web-devicons").setup({
      color_icons = false,
    })
    vim.api.nvim_set_hl(0, 'DevIconDefault', { link = "Identifier" })
  end,
}
