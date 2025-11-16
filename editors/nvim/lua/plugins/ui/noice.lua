return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = { enabled = false },
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
          size = { width = vim.o.columns - 2 },
        }
      },
    },
  },
}
