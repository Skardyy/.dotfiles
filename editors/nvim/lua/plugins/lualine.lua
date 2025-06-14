return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = " ", right = "" }, icon = "" },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            separator = { right = "" }
          },
        },
        lualine_c = {
          {
            "filename",
            separator = { right = "" }
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = true,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            separator = { left = '' },
            update_in_insert = true,
          },
        },
        lualine_y = {
          {
            separator = { left = '' },
            function()
              local l = vim.treesitter.get_parser():lang()
              local lang = l or nil
              return lang and "  " .. lang
            end,
          },
          {
            separator = { left = '' },
            function()
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                if client.name ~= "null-ls" then
                  table.insert(names, client.name)
                end
              end
              return #names > 0 and "  " .. table.concat(names, ", ")
            end,
          },
        },
        lualine_z = {
          {
            function()
              return " " .. vim.fn.line(".") .. ":" .. vim.fn.col(".")
            end,
            separator = { left = '', right = '' },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    })
  end,
}
