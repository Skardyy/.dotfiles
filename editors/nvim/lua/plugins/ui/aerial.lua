-- plugin for having a treeview of the symbols in the current file
return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "prefer_left",
      width = 0.2,
    },
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Struct",
    },
    show_guides = true,
    open_automatic = true,
    highlight_on_hover = true,
    autojump = true,
  },
}
