return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")
    local p = require("luasnip.extras.postfix").postfix
    local f = ls.function_node
    local i = ls.insert_node

    local function wrap_logic(before, after, match)
      local result = before .. match .. after

      if result:find("\n") then
        local lines = {}
        for line in result:gmatch("[^\n]+") do
          table.insert(lines, line)
        end
        return lines
      end

      return result
    end

    local function wrap(before, after)
      return f(function(_, parent)
        local match = parent.snippet.env.POSTFIX_MATCH
        return wrap_logic(before, after, match)
      end, {})
    end

    local function smart_wrap(before, after)
      return {
        f(function(_, parent)
          local match = parent.snippet.env.POSTFIX_MATCH
          if match == "" then
            return before
          end
          return wrap_logic(before, after, match)
        end, {}),
        i(1),
        f(function(_, parent)
          local match = parent.snippet.env.POSTFIX_MATCH
          if match == "" then
            return after
          end
          return ""
        end, {}),
      }
    end

    local function git_commit_wrap(pre, optional_pre, optional_post, post)
      return f(function(_, parent)
        local match = parent.snippet.env.POSTFIX_MATCH
        if match == "" then
          return pre .. post
        else
          return pre .. optional_pre .. match .. optional_post .. post
        end
      end, {})
    end

    local function postfix(trig, nodes)
      return p({ trig = trig, match_pattern = ".*" }, nodes)
    end

    -- RUST
    ls.add_snippets("rust", {
      postfix(".rc", smart_wrap("Rc::new(", ");")),
      postfix(".arc", smart_wrap("Arc::new(", ");")),
      postfix(".mutex", smart_wrap("Mutex::new(", ");")),
      postfix(".rwlock", smart_wrap("RwLock::new(", ");")),
      postfix(".println", smart_wrap('println!("{:?}", ', ");")),
      postfix(".eprintln", smart_wrap('eprintln!("{:?}", ', ");")),
      postfix(".format", smart_wrap('format!("{}", ', ");")),
    })

    -- MARKDOWN
    ls.add_snippets("markdown", {
      postfix(".bold", smart_wrap("**", "**")),
      postfix(".italic", smart_wrap("*", "*")),
      postfix(".code", smart_wrap("`", "`")),
      postfix(".strike", smart_wrap("~~", "~~")),

      postfix(".note", wrap("> [!NOTE]\n> ", "")),
      postfix(".tip", wrap("> [!TIP]\n> ", "")),
      postfix(".important", wrap("> [!IMPORTANT]\n> ", "")),
      postfix(".warning", wrap("> [!WARNING]\n> ", "")),
      postfix(".caution", wrap("> [!CAUTION]\n> ", "")),
    })

    -- 2. GITCOMMIT
    ls.add_snippets("gitcommit", {
      postfix(".feat", git_commit_wrap("feat", "(", ")", ": ")),
      postfix(".fix", git_commit_wrap("fix", "(", ")", ": ")),
      postfix(".chore", git_commit_wrap("chore", "(", ")", ": ")),
      postfix(".doc", git_commit_wrap("docs", "(", ")", ": ")),
      postfix(".refactor", git_commit_wrap("refactor", "(", ")", ": ")),
    })
    ls.filetype_extend("gitcommit", { "markdown" })

    -- TYPESCRIPT AND FRIENDS
    ls.add_snippets("javascript", {
      postfix(".log", smart_wrap("console.log(", ")")),
      postfix(".await", smart_wrap("await ", "")),
      postfix(".json", smart_wrap("JSON.stringify(", ", null, 2)")),
    })
    ls.filetype_extend("typescript", { "javascript" })
    ls.filetype_extend("javascriptreact", { "javascript" })
    ls.filetype_extend("typescriptreact", { "javascript", "javascriptreact" })

    -- PYTHON
    ls.add_snippets("python", {
      postfix(".print", smart_wrap("print(", ")")),
      postfix(".len", smart_wrap("len(", ")")),
    })
  end,
}
