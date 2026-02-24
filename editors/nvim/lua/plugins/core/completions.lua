return {
  "saghen/blink.cmp",
  version = "*",
  config = function()
    local blink = require("blink.cmp")
    local icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    }
    blink.setup({
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        preset = "none",
        ["<C-J>"] = { "select_next", "show", "fallback" },
        ["<C-K>"] = { "select_prev", "show", "fallback" },
        ["<C-Space>"] = { "show", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
          max_height = 10,
          draw = {
            columns = {
              { "kind_icon" },
              { "label",    gap = 1 },
              { "kind" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  return " " .. (icons[ctx.kind] or "") .. " "
                end,
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },
              label = {
                text = function(ctx) return ctx.label end,
                highlight = "BlinkCmpLabel",
              },
              kind = {
                text = function(ctx) return ctx.kind end,
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
            max_width = 80,
            max_height = 10,
          },
        },
      },
      cmdline = {
        keymap = {
          ["<C-J>"] = { "select_next" },
          ["<C-K>"] = { "select_prev" },
        },
        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          show_documentation = true,
          border = "rounded",
        },
        trigger = {
          show_on_accept = true,
          show_on_insert = true,
          show_on_keyword = true
        }
      },
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        providers = {
          snippets = {
            score_offset = -20,
            min_keyword_length = 1,
          },
        },
      },
      fuzzy = {
        sorts = { 'exact', 'score', 'sort_text' },
        use_frecency = false,
        use_proximity = false,
      },
    })
  end,
}
