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
        ["<C-J>"] = { "select_next", "show" },
        ["<C-K>"] = { "select_prev", "show" },
        ["<C-Space>"] = { "show" },
        ["<CR>"] = { "accept" },
      },
      completion = {
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          col_offset = -3,
          side_padding = 0,
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
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
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
        max_typos = function()
          return 0
        end,
      },
    })
  end,
}
