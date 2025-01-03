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
        lualine_a = { "mode" },
        lualine_b = {
          { "branch" },
          { "filename" },
        },
        lualine_c = {
          {
            "diff",
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error" },
          },
          {
            function()
              local lang = vim.treesitter.language.get_lang(vim.api.nvim_buf_get_option(0, "filetype"))
              return lang and " " .. lang .. "🌲" or ""
            end,
          },
          {
            function()
              local clients = vim.lsp.get_active_clients()
              if next(clients) == nil then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                if client.name ~= "null-ls" then
                  table.insert(names, client.name)
                end
              end
              return #names > 0 and " " .. table.concat(names, ", ") .. "💡" or ""
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
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
