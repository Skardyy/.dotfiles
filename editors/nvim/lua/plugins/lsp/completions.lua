return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    config = function()
      local ls = require("luasnip")
      local postfix = require("luasnip.extras.postfix").postfix
      local f = ls.function_node

      local function wrap(before, after)
        return f(function(_, parent)
          return before .. parent.snippet.env.POSTFIX_MATCH .. after
        end, {})
      end

      -- RUST
      ls.add_snippets("rust", {
        postfix(".rc", wrap("Rc::new(", ");")),
        postfix(".arc", wrap("Arc::new(", ");")),
        postfix(".mutex", wrap("Mutex::new(", ");")),
        postfix(".rwlock", wrap("RwLock::new(", ");")),
        postfix(".println", wrap('println!("{:?}", ', ");")),
        postfix(".eprintln", wrap('eprintln!("{:?}", ', ");")),
      })

      -- MARKDOWN
      ls.add_snippets("markdown", {
        postfix(".bold", wrap("**", "**")),
        postfix(".italic", wrap("*", "*")),
        postfix(".code", wrap("`", "`")),
        postfix(".strike", wrap("~~", "~~")),

        postfix(".note", wrap("> [!NOTE]\n> ", "")),
        postfix(".tip", wrap("> [!TIP]\n> ", "")),
        postfix(".important", wrap("> [!IMPORTANT]\n> ", "")),
        postfix(".warning", wrap("> [!WARNING]\n> ", "")),
        postfix(".caution", wrap("> [!CAUTION]\n> ", "")),
      })

      -- 2. GITCOMMIT
      ls.add_snippets("gitcommit", {
        postfix(".feat", wrap("feat(", "): ")),
        postfix(".fix", wrap("fix(", "): ")),
        postfix(".chore", wrap("chore(", "): ")),
        postfix(".doc", wrap("docs(", "): ")),
        postfix(".refactor", wrap("refactor(", "): ")),
      })
      ls.filetype_extend("gitcommit", { "markdown" })

      -- TYPESCRIPT AND FRIENDS
      ls.add_snippets("javascript", {
        postfix(".log", wrap("console.log(", ")")),
        postfix(".await", wrap("await ", "")),
        postfix(".json", wrap("JSON.stringify(", ", null, 2)")),
      })
      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("javascriptreact", { "javascript" })
      ls.filetype_extend("typescriptreact", { "javascript", "javascriptreact" })

      -- PYTHON
      ls.add_snippets("python", {
        postfix(".print", wrap("print(", ")")),
        postfix(".len", wrap("len(", ")")),
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-cmdline',
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
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
        mapping = {
          ["<C-K>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.complete()
            end
          end, { "i", "c" }),

          ["<C-J>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.complete()
            end
          end, { "i", "c" }),

          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
        },
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  }
}
