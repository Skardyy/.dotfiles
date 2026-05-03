return {
  'stevearc/conform.nvim',
  event = "VeryLazy",
  config = function()
    local formatters = {}
    for ft, tools in pairs(vim.g.lang_maps) do
      if tools.formatter then
        formatters[ft] = { tools.formatter.conform }
      end
    end
    require("conform").setup({
      formatters_by_ft = formatters,
      default_format_opts = {
        lsp_format = "fallback",
      },
    })
  end,
}
