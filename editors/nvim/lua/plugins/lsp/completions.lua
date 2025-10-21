return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    'hrsh7th/cmp-cmdline',
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require("cmp")
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
    cmp.setup({
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          col_offset = -3,
          side_padding = 0,
          max_height = 10,
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          max_width = 80,
          max_height = 10,
        },
      },
      formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(_, vim_item)
          local kind_hl_group = "CmpItemKind" .. vim_item.kind
          vim_item.menu = string.format(" %s ", icons[vim_item.kind])
          vim_item.menu_hl_group = kind_hl_group
          return vim_item
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      experimental = {
        ghost_text = false,
      },
      preselect = cmp.PreselectMode.None,
      sorting = {
        priority_weight = 1.0,
        comparators = {
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.score,
          cmp.config.compare.offset,
          cmp.config.compare.order,
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
        ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}
