return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")
    local p = require("luasnip.extras.postfix").postfix
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
      postfix(".rc", wrap("Rc::new(", ");")),
      postfix(".arc", wrap("Arc::new(", ");")),
      postfix(".mutex", wrap("Mutex::new(", ");")),
      postfix(".rwlock", wrap("RwLock::new(", ");")),
      postfix(".println", wrap('println!("{:?}", ', ");")),
      postfix(".eprintln", wrap('eprintln!("{:?}", ', ");")),
      postfix(".format", wrap('format!("{}", ', ");")),
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
      postfix(".feat", git_commit_wrap("feat", "(", ")", ": ")),
      postfix(".fix", git_commit_wrap("fix", "(", ")", ": ")),
      postfix(".chore", git_commit_wrap("chore", "(", ")", ": ")),
      postfix(".doc", git_commit_wrap("docs", "(", ")", ": ")),
      postfix(".refactor", git_commit_wrap("refactor", "(", ")", ": ")),
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
}
