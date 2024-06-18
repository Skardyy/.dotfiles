return {
  "folke/noice.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        views = {
            notify = {
              view = "mini", -- Use the mini view for notifications
            },
          },
      }
    end
}
