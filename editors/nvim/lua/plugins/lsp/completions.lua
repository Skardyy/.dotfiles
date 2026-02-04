return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "InsertEnter",
    config = function()
      local ls = require("luasnip")
      local postfix = require("luasnip.extras.postfix").postfix
      local f = ls.function_node

      local function wrap(before, after)
        return f(function(_, parent)
          local match = parent.snippet.env.POSTFIX_MATCH
          local result = before .. match .. after

          if result:find("\n") then
            local lines = {}
            for line in result:gmatch("[^\n]+") do
              table.insert(lines, line)
            end
            return lines
          end

          return result
        end, {})
      end

      local function smart_wrap(pre, optional_pre, optional_post, post)
        return f(function(_, parent)
          local match = parent.snippet.env.POSTFIX_MATCH
          if match == "" then
            return pre .. post
          else
            return pre .. optional_pre .. match .. optional_post .. post
          end
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

        postfix({ trig = ".note", match_pattern = ".*" }, wrap("> [!NOTE]\n> ", "")),
        postfix({ trig = ".tip", match_pattern = ".*" }, wrap("> [!TIP]\n> ", "")),
        postfix({ trig = ".important", match_pattern = ".*" }, wrap("> [!IMPORTANT]\n> ", "")),
        postfix({ trig = ".warning", match_pattern = ".*" }, wrap("> [!WARNING]\n> ", "")),
        postfix({ trig = ".caution", match_pattern = ".*" }, wrap("> [!CAUTION]\n> ", "")),
      })

      -- 2. GITCOMMIT
      ls.add_snippets("gitcommit", {
        postfix({ trig = ".feat", match_pattern = ".*" }, smart_wrap("feat", "(", ")", ": ")),
        postfix({ trig = ".fix", match_pattern = ".*" }, smart_wrap("fix", "(", ")", ": ")),
        postfix({ trig = ".chore", match_pattern = ".*" }, smart_wrap("chore", "(", ")", ": ")),
        postfix({ trig = ".doc", match_pattern = ".*" }, smart_wrap("docs", "(", ")", ": ")),
        postfix({ trig = ".refactor", match_pattern = ".*" }, smart_wrap("refactor", "(", ")", ": ")),
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
    event = { "InsertEnter" },
    dependencies = {
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
          end, { "i" }),

          ["<C-J>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.complete()
            end
          end, { "i" }),

          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i" }),
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
