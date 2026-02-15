return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = { enabled = false },
    },
    cmdline = {
      view = "cmdline",
      format = {
        input = { view = "cmdline_input" },
      },
    },
    presets = {
      bottom_search = true,
    },
    views = {
      cmdline_input = {
        position = {
          row = "99%",
        },
        size = {
          width = "96%",
        },
        border = {
          style = "rounded",
        },
      },
      hover = {
        border = {
          style = "rounded",
        },
      },
    },
  },
}
