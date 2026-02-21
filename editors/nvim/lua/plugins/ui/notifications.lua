return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = { enabled = false },
      signature = { enabled = false },
      hover = { enabled = false }
    },
    cmdline = {
      view = "cmdline",
    },
    presets = {
      bottom_search = true,
    },
    views = {
      hover = {
        border = {
          style = "rounded",
        },
      },
    },
    routes = {
      {
        filter = { kind = { "confirm", "input" } },
        view = "cmdline",
        opts = {
          border = { style = "rounded" },
          position = {
            row = -1,
            col = 1,
          },
          relative = "editor",
          size = {
            width = "99%",
          },
        }
      },
    },
  },
}
