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
  config = function(_, opts)
    local auto_open_enabled = true

    opts.open_automatic = function(bufnr)
      return auto_open_enabled and not require("aerial.util").is_ignored_buf(bufnr)
    end

    require("aerial").setup(opts)
    vim.keymap.set("n", "<leader>o", function()
      require("telescope").extensions.aerial.aerial({
        default_selection_index = 1,
      })
    end, { silent = true, desc = "Find symbols" })

    vim.keymap.set("n", "<leader>a", function()
      local aerial = require("aerial")
      if aerial.is_open() then
        auto_open_enabled = false
        aerial.close_all()
      else
        auto_open_enabled = true
        aerial.open()
      end
    end, { silent = true, desc = "Toggle aerial with auto-open" })
  end
}
