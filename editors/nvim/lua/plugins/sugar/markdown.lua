return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  ---@type markview.config
  opts = {
    preview = {
      enable = false
    },
    markdown = {
      list_items = {
        marker_dot = {
          conceal_on_checkboxes = false,
          add_padding = false
        },
        marker_plus = {
          add_padding = false
        },
        marker_minus = {
          add_padding = false
        },
        marker_star = {
          add_padding = false
        },
        marker_parenthesis = {
          add_padding = false
        }
      }
    },
    markdown_inline = {
      checkboxes = {
        checked = {
          text = " 󰱒 ",
          hl = "DiagnosticOk",
        },
        unchecked = {
          text = " 󰄱 ",
          hl = "DiagnosticError",
        }
      },
    }
  },
  keys = {
    {
      "<leader>t",
      "<cmd>Markview toggle<cr>",
      desc = "Toggle Markview",
    },
  },
}
