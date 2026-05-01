return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  ---@type markview.config
  opts = {
    preview = {
      enable = false,
      ignore_buftypes = {},
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
      inline_codes = {
        enable = false
      },
      checkboxes = {
        checked = {
          text = " 󰱒 ",
        },
        unchecked = {
          text = " 󰄱 ",
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
