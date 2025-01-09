return {
  "declancm/cinnamon.nvim",
  version = "*",
  config = function()
    require("cinnamon").setup {
      keymaps = {
        basic = true,
        extra = true,
      },
      options = {
        mode = "window",
        max_delta = {
          time = 100
        }
      },
    }
  end
}
