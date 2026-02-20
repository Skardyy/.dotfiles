return {
  "rcarriga/nvim-notify",
  opts = {
    render = "compact",
    stages = "static",
    top_down = false,
    max_width = 40,
    max_height = 3,
    timeout = 3000,
  },
  config = function(_, opts)
    require("notify").setup(opts)
    vim.notify = require("notify")
    print = require("notify")
  end,
}
